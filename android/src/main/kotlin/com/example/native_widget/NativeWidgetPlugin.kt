package com.example.native_widget

import android.app.Activity
import android.content.Context
import android.content.Intent
import androidx.work.ExistingPeriodicWorkPolicy
import androidx.work.PeriodicWorkRequestBuilder
import androidx.work.WorkManager
import com.example.native_widget.methodsFrom
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
import java.util.concurrent.TimeUnit

class NativeWidgetPlugin : FlutterPlugin, MethodCallHandler, ActivityAware,
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
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "native_widget")
    channel.setMethodCallHandler(this)


    eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "native_widget/events")
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
        result.success(AppSharedPreferences.getTimelinesData(context))
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
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
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

