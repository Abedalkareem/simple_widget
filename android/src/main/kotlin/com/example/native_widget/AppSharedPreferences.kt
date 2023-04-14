package com.example.native_widget

import android.content.Context

object AppSharedPreferences {

  private const val key = "TimelineData"

  fun save(string: String, context: Context) {
    val sharedPreference =  context.getSharedPreferences(key, Context.MODE_PRIVATE)
    val editor = sharedPreference.edit()
    editor.putString("data", string)
    editor.apply()
  }
}