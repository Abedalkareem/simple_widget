package com.example.simple_widget

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.os.Handler
import android.os.Looper
import androidx.work.ExistingPeriodicWorkPolicy
import androidx.work.PeriodicWorkRequestBuilder
import androidx.work.WorkManager
import com.example.simple_widget.methodsFrom
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import java.util.concurrent.Executors
import java.util.concurrent.TimeUnit

class SimpleWidgetPlugin : FlutterPlugin, MethodCallHandler, ActivityAware,
  EventChannel.StreamHandler, PluginRegistry.NewIntentListener {

  //region Variables
  private lateinit var channel: MethodChannel
  private lateinit var context: Context
  private var activity: Activity? = null

  private lateinit var eventChannel: EventChannel
  private var eventSink: EventSink? = null
  //endregion

  //region FlutterPlugin
  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "simple_widget")
    channel.setMethodCallHandler(this)


    eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "simple_widget/events")
    eventChannel.setStreamHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    val method = methodsFrom(call.method)
    if (method == null) {
      result.error(
        PluginError.NotImplemented.code(),
        PluginError.NotImplemented.message(),
        PluginError.NotImplemented.details()
      )
      return
    }
    when (method) {
      Method.UpdateWidgets -> {
        val arguments = call.arguments as? String
        if (arguments == null) {
          result.error(
            PluginError.WrongArguments.code(),
            PluginError.WrongArguments.message(),
            PluginError.WrongArguments.details()
          )
          return
        }
        AppSharedPreferences.save(arguments, context)

        // Redraw straight away. The periodic worker below exists to roll a
        // timeline over to its next dated entry, and leaving the redraw to it
        // meant a change the user just made sat invisible on the home screen
        // until that job happened to run.
        WidgetRefresher.refresh(context)

        val widgetUpdateRequest = PeriodicWorkRequestBuilder<WidgetUpdateWorker>(
          30, TimeUnit.MINUTES
        ).build()
        WorkManager.getInstance(context).enqueueUniquePeriodicWork(
          "widgetUpdateWork",
          ExistingPeriodicWorkPolicy.REPLACE,
          widgetUpdateRequest
        )

        result.success(null)
      }
      Method.GetTimelinesData -> {
        // Migration base64-decodes, hashes and writes every stored image, and
        // reading the timelines can block on the SharedPreferences load. Both
        // are far too slow for the platform thread on an account with a large
        // legacy payload, which showed up in the field as a startup ANR.
        onBackgroundThread(result) {
          MigrationHelper.migrateBase64ToFiles(context)
          AppSharedPreferences.getTimelinesData(context)
        }
      }
      Method.RefreshWidgets -> {
        WidgetRefresher.refresh(context, result)
      }
      Method.SetGroupID -> {
        result.success(null)
      }
      Method.GetLaunchedURL -> {
        val value = activity?.intent?.data?.toString() ?: ""
        if (check(value)) {
          result.success(value)
        } else {
          result.success(null)
        }
      }
      Method.SetAppScheme -> {
        val arguments = call.arguments as? String
        if (arguments == null) {
          result.error(
            PluginError.WrongArguments.code(),
            PluginError.WrongArguments.message(),
            PluginError.WrongArguments.details()
          )
          return
        }
        Settings.appScheme = arguments
        result.success(null)
      }
      Method.SaveImageFile -> {
        val arguments = call.arguments as? Map<*, *>
        if (arguments == null) {
          result.error(
            PluginError.WrongArguments.code(),
            PluginError.WrongArguments.message(),
            PluginError.WrongArguments.details()
          )
          return
        }
        val bytes = arguments["bytes"] as? ByteArray
        if (bytes == null) {
          result.error(
            PluginError.WrongArguments.code(),
            PluginError.WrongArguments.message(),
            PluginError.WrongArguments.details()
          )
          return
        }
        val filename = arguments["filename"] as? String
        val path = ImageFileManager.saveImage(context, bytes, filename)
        result.success(path)
      }
      Method.DeleteImageFiles -> {
        val arguments = call.arguments as? List<*>
        if (arguments == null) {
          result.error(
            PluginError.WrongArguments.code(),
            PluginError.WrongArguments.message(),
            PluginError.WrongArguments.details()
          )
          return
        }
        val paths = arguments.filterIsInstance<String>()
        ImageFileManager.deleteImages(context, paths)
        result.success(null)
      }
      Method.MigrateToFileStorage -> {
        onBackgroundThread(result) { MigrationHelper.migrateBase64ToFiles(context) }
      }
      Method.GetImageBasePath -> {
        result.success(ImageFileManager.getBasePath(context))
      }
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  /// Runs [work] off the platform thread and delivers its value back on the
  /// platform thread, where a MethodChannel result has to be answered.
  private fun onBackgroundThread(result: Result, work: () -> Any?) {
    backgroundExecutor.execute {
      val value = try {
        work()
      } catch (t: Throwable) {
        mainHandler.post {
          result.error(
            PluginError.Unknown.code(),
            t.message ?: PluginError.Unknown.message(),
            PluginError.Unknown.details()
          )
        }
        return@execute
      }
      mainHandler.post { result.success(value) }
    }
  }
  //endregion

  //region ActivityAware
  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
    binding.addOnNewIntentListener(this)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activity = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity
    binding.addOnNewIntentListener(this)
  }

  override fun onDetachedFromActivity() {
    activity = null
  }
  //endregion

  //region StreamHandler
  override fun onListen(arguments: Any?, events: EventSink) {
    eventSink = events
  }

  override fun onCancel(arguments: Any?) {
    eventSink = null
  }
  //endregion

  //region NewIntentListener
  override fun onNewIntent(intent: Intent): Boolean {
    // Update the activity's intent so getLaunchedURL() returns the latest
    // deep link, not the stale one from the original cold start.
    activity?.intent = intent
    val value = intent.data?.toString() ?: ""
    if (check(value)) {
      eventSink?.success(value)
      return true
    }
    return false
  }

  private fun check(url: String): Boolean {
    assert(Settings.appScheme != null) { "Please set the appScheme using `setAppScheme`" }
    return Settings.appScheme?.let { url.contains(it) } ?: false
  }
  //endregion
}

// Migration and the timeline read are the only genuinely slow method calls, and
// both are one-shot work with no ordering requirement between them, so a single
// thread keeps them off the platform thread without spawning per call. Process
// scoped, so repeatedly attaching and detaching an engine cannot leak threads.
private val backgroundExecutor = Executors.newSingleThreadExecutor()
private val mainHandler = Handler(Looper.getMainLooper())
