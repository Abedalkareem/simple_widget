package com.example.native_widget

enum class Method {
  UpdateWidgets, RefreshWidgets, SetGroupID, GetLaunchedURL, SetAppScheme
}

fun Method.value(): String {
  return "$this".lowercase()
}

fun methodsFrom(string: String): Method? {
  return Method.values().firstOrNull { it.value() == string.lowercase() }
}