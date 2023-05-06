//
//  AppWidget.swift
//  WidgetExampleExtension
//
//  Created by abedalkareem omreyh on 09/04/2023.
//

import SwiftUI
import WidgetKit

struct AppWidget: Widget {

  // MARK: - Properties
  
  let kind: String = "AppWidget"

  // MARK: - Body

  var body: some WidgetConfiguration {
    IntentConfiguration(kind: kind,
                        intent: SelectWidgetIntent.self,
                        provider: Provider()) { entry in
      AppWidgetEntryView(entry: entry)
    }
                        .configurationDisplayName("AppWidget")
                        .description("This is an example widget :)")
                        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
  }
}
