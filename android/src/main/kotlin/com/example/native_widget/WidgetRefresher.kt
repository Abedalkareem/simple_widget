package com.example.native_widget

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import io.flutter.plugin.common.MethodChannel

object WidgetRefresher {

  fun refresh(context: Context, result: MethodChannel.Result? = null) {
    val className = "NativeWidgetProvider"
    try {
      val javaClass = Class.forName("${context.packageName}.${className}")
      val intent = Intent(context, javaClass)
      intent.action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
      val ids: IntArray =
        AppWidgetManager.getInstance(context.applicationContext).getAppWidgetIds(
          ComponentName(context, javaClass)
        )
      intent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, ids)
      context.sendBroadcast(intent)
      result?.success(null)
    } catch (classException: ClassNotFoundException) {
      result?.error(
        PluginError.NoWidgetFound.code(),
        PluginError.NoWidgetFound.message(),
        PluginError.NoWidgetFound.details()
      )
    }
  }

}