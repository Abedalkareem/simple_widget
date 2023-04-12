//
//  IntentHandler.swift
//  IntentsExtension
//
//  Created by abedalkareem omreyh on 09/04/2023.
//

import Intents

class IntentHandler: INExtension, SelectWidgetIntentHandling {
  func resolveType(for intent: SelectWidgetIntent, with completion: @escaping (WidgetTypeObjectResolutionResult) -> Void) {

    if let type = intent.type {
      completion(.success(with: type))
    }
  }

  func provideTypeOptionsCollection(for intent: SelectWidgetIntent, with completion: @escaping (INObjectCollection<WidgetTypeObject>?, Error?) -> Void) {

    let widgets: [WidgetTypeObject] = AppUserDefaults.shared.getWidgets().map({
      let obj = WidgetTypeObject(identifier: $0.id, display: $0.id)
      obj.type = $0.id
      obj.name = $0.id
      return obj
    })

    let collection = INObjectCollection(items: widgets)
    completion(collection, nil)
  }

}
