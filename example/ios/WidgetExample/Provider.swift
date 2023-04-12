//
//  Provider.swift
//  WidgetExampleExtension
//
//  Created by abedalkareem omreyh on 09/04/2023.
//

import WidgetKit

struct Provider: IntentTimelineProvider {

  func placeholder(in context: Context) -> AppWidgetEntry {
    if let widget = AppUserDefaults.shared.getWidgets().first {
      let entry = AppWidgetEntry(date: Date(), configuration: SelectWidgetIntent(), appWidgetData: widget)
      return entry
    } else {
      return emptyWidgetEntry()
    }
  }

  func getSnapshot(for configuration: SelectWidgetIntent, in context: Context, completion: @escaping (AppWidgetEntry) -> ()) {
    if let widget = AppUserDefaults.shared.getWidgets().first {
      let entry = AppWidgetEntry(date: Date(), configuration: configuration, appWidgetData: widget)
      completion(entry)
    } else {
      completion(emptyWidgetEntry())
    }
  }

  func getTimeline(for configuration: SelectWidgetIntent, in context: Context, completion: @escaping (Timeline<AppWidgetEntry>) -> ()) {
    var entries: [AppWidgetEntry] = []

    // Generate a timeline consisting of five entries an hour apart, starting from the current date.
    //    let currentDate = Date()
    //    for hourOffset in 0 ..< 5 {
    //      let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
    //      let entry = AppWidgetEntry(date: entryDate, configuration: configuration)
    //      entries.append(entry)
    //    }

    let type = configuration.type?.type

    let entry = AppUserDefaults.shared.getWidgets().first(where: { $0.id == type }).map { data in
      AppWidgetEntry(date: Date(), configuration: configuration, appWidgetData: data)
    } ?? AppUserDefaults.shared.getWidgets().first.map({ data in
      AppWidgetEntry(date: Date(), configuration: configuration, appWidgetData: data)
    })

    if let entry {
      entries.append(entry)
    }

    let timeline = Timeline(entries: entries, policy: .atEnd)
    completion(timeline)
  }

  private func emptyWidgetEntry() -> AppWidgetEntry {
    return AppWidgetEntry(date: Date(), configuration: SelectWidgetIntent(), appWidgetData: AppWidgetData(id: "", background: "", foreground: ""))
  }
}

struct AppWidgetEntry: TimelineEntry {
  let date: Date
  let configuration: SelectWidgetIntent
  let appWidgetData: AppWidgetData
}

struct AppWidgetData: Codable {
  let id: String
  let background: String
  let foreground: String
}
