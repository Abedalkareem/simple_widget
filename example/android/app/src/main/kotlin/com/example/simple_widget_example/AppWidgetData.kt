package com.example.simple_widget_example

data class AppWidgetData(
  val date: Long,
  val id: String?,
  val background: String?,
  val foreground: String?
)

data class TimelineData(
  val id: String,
  val type: String,
  val data: List<AppWidgetData>
)