package com.example.native_widget_example

import android.content.Context
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken

object AppSharedPreferences {

  private const val key = "AppWidgetsData"

  fun getWidgets(context: Context): List<AppWidgetData> {
    val widgetData = context.getSharedPreferences("AppWidgetsData", Context.MODE_PRIVATE)
    val value = widgetData.getString("data", "")
    val typeToken = object : TypeToken<List<AppWidgetData>>() {}.type
    return Gson().fromJson(value, typeToken)
  }
}