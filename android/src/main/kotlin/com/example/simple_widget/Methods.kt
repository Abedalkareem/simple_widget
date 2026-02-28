package com.example.simple_widget

enum class Method {
  UpdateWidgets, RefreshWidgets, SetGroupID, GetLaunchedURL, SetAppScheme, GetTimelinesData,
  SaveImageFile, DeleteImageFiles, MigrateToFileStorage, GetImageBasePath
}

fun Method.value(): String {
  return "$this".lowercase()
}

fun methodsFrom(string: String): Method? {
  return Method.values().firstOrNull { it.value() == string.lowercase() }
}