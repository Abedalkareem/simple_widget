//
//  WidgetExample.swift
//  WidgetExample
//
//  Created by abedalkareem omreyh on 09/04/2023.
//

import WidgetKit
import SwiftUI
import Intents

struct AppWidgetEntryView : View {
  
  // MARK: - Properties
  
  var entry: AppWidgetEntry
  
  // MARK: - Body
  
  var body: some View {
    let forgroundWidget =
    Image(uiImage: loadImage(entry.appWidgetData.foreground))
      .resizable()
      .scaledToFit()
      .widgetURL(URL(string: "\(Settings.appScheme)://data?id=\(entry.appWidgetData.id)"))

    let backgroundWidget = Image(uiImage: loadImage(entry.appWidgetData.background))
      .resizable()
      .scaledToFill()
    
    if #available(iOSApplicationExtension 17.0, *) {
      return forgroundWidget.containerBackground(for: .widget) {
        backgroundWidget
      }
    } else {
      return ZStack {
        backgroundWidget
        forgroundWidget
      }
    }
  }
  
  // MARK: -

  private func loadImage(_ value: String) -> UIImage {
    if value.hasPrefix("widget_images/") {
      if let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Settings.groupId) {
        let fileURL = containerURL.appendingPathComponent(value)
        if let data = try? Data(contentsOf: fileURL) {
          return UIImage(data: data) ?? .init()
        }
      }
      return .init()
    }
    return UIImage(data: Data(base64Encoded: value) ?? .init()) ?? .init()
  }
}

// MARK: - Previews

struct WidgetExample_Previews: PreviewProvider {
  static var previews: some View {
    AppWidgetEntryView(entry: AppWidgetEntry(date: Date(), configuration:  SelectWidgetIntent(), appWidgetData: AppWidgetData(date: 55, id: "", background: "", foreground: "")))
      .previewContext(WidgetPreviewContext(family: .systemSmall))
  }
}
