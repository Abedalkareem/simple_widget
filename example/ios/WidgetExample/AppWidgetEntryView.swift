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
    ZStack {
      Image(uiImage: base64ToImage(base64: entry.appWidgetData.background))
        .resizable()
        .scaledToFill()
      Image(uiImage: base64ToImage(base64: entry.appWidgetData.foreground))
        .resizable()
        .scaledToFit()
    }
    .widgetURL(URL(string: "\(Settings.appScheme)://data?id=\(entry.appWidgetData.id)"))
  }

  // MARK: -

  private func base64ToImage(base64: String) -> UIImage {
    UIImage(data: Data(base64Encoded: base64) ?? .init()) ?? .init()
  }
}

// MARK: - Previews

struct WidgetExample_Previews: PreviewProvider {
  static var previews: some View {
    AppWidgetEntryView(entry: AppWidgetEntry(date: Date(), configuration:  SelectWidgetIntent(), appWidgetData: AppWidgetData(id: "", background: "", foreground: "")))
      .previewContext(WidgetPreviewContext(family: .systemSmall))
  }
}
