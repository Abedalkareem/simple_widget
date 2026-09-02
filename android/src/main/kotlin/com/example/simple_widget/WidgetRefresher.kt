package com.example.simple_widget

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import io.flutter.plugin.common.MethodChannel

object WidgetRefresher {

  fun refresh(context: Context, result: MethodChannel.Result? = null) {
    val className = "SimpleWidgetProvider"
    try {
      Class.forName("${context.packageName}.${className}")
    } catch (classException: ClassNotFoundException) {
      result?.error(
        PluginError.NoWidgetFound.code(),
        PluginError.NoWidgetFound.message(),
        PluginError.NoWidgetFound.details()
      )
      return
    }

    // Broadcast to every widget provider the package declares, each with its
    // own ids. Only asking SimpleWidgetProvider for ids meant an app whose
    // widgets were all placed from provider subclasses built an empty id
    // array, and AppWidgetProvider.onReceive drops an update carrying no ids,
    // so onUpdate never ran and in-app changes never reached the home screen.
    val manager = AppWidgetManager.getInstance(context.applicationContext)
    for (provider in manager.getInstalledProvidersForPackage(context.packageName, null)) {
      val ids = manager.getAppWidgetIds(provider.provider)
      if (ids.isEmpty()) {
        continue
      }
      val intent = Intent(AppWidgetManager.ACTION_APPWIDGET_UPDATE)
      intent.component = provider.provider
      intent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, ids)
      context.sendBroadcast(intent)
    }
    result?.success(null)
  }
}
