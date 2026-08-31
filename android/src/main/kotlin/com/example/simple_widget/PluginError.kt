package com.example.simple_widget

enum class PluginError {
  WrongArguments, NotImplemented, NoWidgetFound, Unknown
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
    PluginError.Unknown -> {
      "99"
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
    PluginError.Unknown -> {
      "Unexpected error"
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
      "No widget found, Make sure you added the `SimpleWidgetProvider` in your app"
    }
    PluginError.Unknown -> {
      "The method failed with an unexpected error"
    }
  }
}