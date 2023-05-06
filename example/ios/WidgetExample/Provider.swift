//
//  Provider.swift
//  WidgetExampleExtension
//
//  Created by abedalkareem omreyh on 09/04/2023.
//

import WidgetKit

struct Provider: IntentTimelineProvider {

  func placeholder(in context: Context) -> AppWidgetEntry {
    if let widget = Storage.shared.getTimelines().first?.data.first {
      let entry = AppWidgetEntry(date: Date(), configuration: SelectWidgetIntent(), appWidgetData: widget)
      return entry
    } else {
      return emptyWidgetEntry()
    }
  }

  func getSnapshot(for configuration: SelectWidgetIntent, in context: Context, completion: @escaping (AppWidgetEntry) -> ()) {
    if let widget = Storage.shared.getTimelines().first?.data.first {
      let entry = AppWidgetEntry(date: Date(), configuration: configuration, appWidgetData: widget)
      completion(entry)
    } else {
      completion(emptyWidgetEntry())
    }
  }

  func getTimeline(for configuration: SelectWidgetIntent, in context: Context, completion: @escaping (Timeline<AppWidgetEntry>) -> ()) {
    var entries: [AppWidgetEntry] = []


    let type = configuration.type?.type
    let timelineData = Storage.shared.getTimelines().first(where: { $0.type == type }) ?? Storage.shared.getTimelines().first
    // Generate a timeline consisting of five entries an hour apart, starting from the current date.

    if let timelineData {
      for widget in timelineData.data {
        let entryDate = Date(timeIntervalSince1970: TimeInterval(widget.date / 1000))
        let entry = AppWidgetEntry(date: entryDate, configuration: configuration, appWidgetData: widget)
        entries.append(entry)
      }
    }

    let timeline = Timeline(entries: entries, policy: .atEnd)
    completion(timeline)
  }

  private func emptyWidgetEntry() -> AppWidgetEntry {
    return AppWidgetEntry(date: Date(), configuration: SelectWidgetIntent(), appWidgetData: AppWidgetData(date: Int(Date().timeIntervalSince1970), id: "", background: "", foreground: ""))
  }
}

struct AppWidgetEntry: TimelineEntry {
  let date: Date
  let configuration: SelectWidgetIntent
  let appWidgetData: AppWidgetData
}

struct TimelineData: Codable {
  let id: String
  let type: String
  let data: [AppWidgetData]
}

struct AppWidgetData: Codable {
  let date: Int
  let id: String
  let background: String
  let foreground: String
}
