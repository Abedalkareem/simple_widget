package com.example.simple_widget_example

import android.app.Activity
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.net.Uri
import android.os.Build
import android.util.Base64
import android.widget.RemoteViews
import java.io.File

class SimpleWidgetProvider : AppWidgetProvider() {

  override fun onUpdate(
    context: Context,
    appWidgetManager: AppWidgetManager,
    appWidgetIds: IntArray
  ) {
    super.onUpdate(context, appWidgetManager, appWidgetIds)
    val allTimelines = AppSharedPreferences.getTimelines(context)

    appWidgetIds.forEach { widgetId ->
      var timeline = allTimelines.firstOrNull()
      val timelineWithID = allTimelines.firstOrNull { it.id == "$widgetId" }
      if (timelineWithID != null) {
        timeline = timelineWithID
      }
      if (timeline == null) {
        return@forEach
      }
      val timelineData = timeline.data.sortedBy { it.date }
      val widgetToShow = timelineData.lastOrNull {
        val currentTime = System.currentTimeMillis()
        val widgetTime = it.date
        return@lastOrNull widgetTime <= currentTime
      } ?: return@forEach
      val views = RemoteViews(context.packageName, R.layout.widget_layout).apply {

        // Set the widget background
        setImageViewBitmap(
          R.id.backgroundImageView,
          loadImage(context, widgetToShow.background ?: "")
        )

        // Set the widget foreground
        setImageViewBitmap(
          R.id.foregroundImageView,
          loadImage(context, widgetToShow.foreground ?: "")
        )

        // Open App on Widget Click
        val pendingIntent = getActivity(
          context,
          MainActivity::class.java,
          Uri.parse("${Settings.appScheme}://data?id=$widgetId")
        )
        setOnClickPendingIntent(R.id.container, pendingIntent)
      }

      appWidgetManager.updateAppWidget(widgetId, views)
    }
  }

  override fun onReceive(context: Context?, intent: Intent?) {
    super.onReceive(context, intent)
  }

  private fun loadImage(context: Context, value: String): Bitmap? {
    if (value.startsWith("widget_images/")) {
      val file = File(context.filesDir, value)
      if (file.exists()) {
        return BitmapFactory.decodeFile(file.absolutePath)
      }
      return null
    }
    val decodedString = Base64.decode(value, Base64.DEFAULT)
    return BitmapFactory.decodeByteArray(decodedString, 0, decodedString.size)
  }

  private fun <T> getActivity(
    context: Context,
    activityClass: Class<T>,
    uri: Uri? = null
  ): PendingIntent where T : Activity {
    val intent = Intent(context, activityClass)
    intent.data = uri

    var flags = PendingIntent.FLAG_UPDATE_CURRENT
    if (Build.VERSION.SDK_INT >= 23) {
      flags = flags or PendingIntent.FLAG_IMMUTABLE
    }

    return PendingIntent.getActivity(context, 0, intent, flags)
  }
}