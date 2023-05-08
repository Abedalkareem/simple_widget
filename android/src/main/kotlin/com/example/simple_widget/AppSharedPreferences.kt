package com.example.simple_widget

import android.content.Context

object AppSharedPreferences {

  private const val key = "TimelineData"

  fun save(string: String, context: Context) {
    val sharedPreference =  context.getSharedPreferences(key, Context.MODE_PRIVATE)
    val editor = sharedPreference.edit()
    editor.putString("data", string)
    editor.apply()
  }

  fun getTimelinesData(context: Context): String? {
    val sharedPreference =  context.getSharedPreferences(key, Context.MODE_PRIVATE)
    return sharedPreference.getString("data", null)
  }
}