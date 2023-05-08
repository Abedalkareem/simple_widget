package com.example.simple_widget_example

import android.content.Context
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken

object AppSharedPreferences {

  private const val key = "TimelineData"

  fun getTimelines(context: Context): List<TimelineData> {
    val widgetData = context.getSharedPreferences(key, Context.MODE_PRIVATE)
    val value = widgetData.getString("data", "")
    val typeToken = object : TypeToken<List<TimelineData>>() {}.type
    if (value?.isEmpty() != false) {
      return listOf()
    }
    return Gson().fromJson(value, typeToken)
  }
}