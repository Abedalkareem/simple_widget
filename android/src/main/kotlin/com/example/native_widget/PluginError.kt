package com.example.native_widget

enum class PluginError {
  WrongArguments, NotImplemented, NoWidgetFound
}

fun PluginError.code(): String {
  return when (this) {
    PluginError.WrongArguments -> {
      "22"
    }
    PluginError.NotImplemented -> {
      "44"
    }
    PluginError.NoWidgetFound -> {
      "55"
    }
  }
}

fun PluginError.message(): String {
  return when (this) {
    PluginError.WrongArguments -> {
      "Wrong arguments type"
    }
    PluginError.NotImplemented -> {
      "Not implemented"
    }
    PluginError.NoWidgetFound -> {
      "No widget found"
    }
  }
}

fun PluginError.details(): String {
  return when (this) {
    PluginError.WrongArguments -> {
      "Wrong arguments type, the arguments should be string"
    }
    PluginError.NotImplemented -> {
      "Method not implemented"
    }
    PluginError.NoWidgetFound -> {
      "No widget found, Make sure you added the `AppWidgetProvider` in your app"
    }
  }
}