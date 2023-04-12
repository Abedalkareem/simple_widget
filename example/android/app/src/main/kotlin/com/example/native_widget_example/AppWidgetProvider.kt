package com.example.native_widget_example

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

class AppWidgetProvider : AppWidgetProvider() {

  override fun onUpdate(
    context: Context,
    appWidgetManager: AppWidgetManager,
    appWidgetIds: IntArray
  ) {
    val allWidgets = AppSharedPreferences.getWidgets(context)
    appWidgetIds.forEach { widgetId ->
      var widgetToShow = allWidgets.firstOrNull()
      val widgetWithID = allWidgets.firstOrNull { it.id == "$widgetId" }
      if (widgetWithID != null) {
        widgetToShow = widgetWithID
      }
      val views = RemoteViews(context.packageName, R.layout.widget_layout).apply {

        // Set the widget background
        setImageViewBitmap(
          R.id.backgroundImageView,
          base64ToBitmap(widgetToShow?.background ?: "")
        )

        // Set the widget foreground
        setImageViewBitmap(
          R.id.foregroundImageView,
          base64ToBitmap(widgetToShow?.foreground ?: "")
        )

        // Open App on Widget Click
        val pendingIntent = HomeWidgetLaunchIntent.getActivity(
          context,
          MainActivity::class.java,
          Uri.parse("${Settings.appScheme}://data?id=$widgetId")
        )
        setOnClickPendingIntent(R.id.container, pendingIntent)
      }

      appWidgetManager.updateAppWidget(widgetId, views)
    }
  }

  private fun base64ToBitmap(base64: String): Bitmap {
    val decodedString = Base64.decode(base64, Base64.DEFAULT)
    return BitmapFactory.decodeByteArray(decodedString, 0, decodedString.size)
  }
}

object HomeWidgetLaunchIntent {


  fun <T> getActivity(
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
