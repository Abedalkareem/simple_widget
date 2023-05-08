//
//  Errors.swift
//  simple_widget
//
//  Created by abedalkareem omreyh on 11/04/2023.
//

import Foundation
import Flutter

enum Errors {
  static let wrongArguments = FlutterError(code: "22",
                                           message: "Wrong arguments type",
                                           details: "Wrong arguments type, the arguments should be string")
  static let notSupported = FlutterError(code: "33",
                                         message: "Not supported",
                                         details: "This feature not supported for iOS versions lower than 14")
  static let notImplemented = FlutterError(code: "44",
                                           message: "Not implemented",
                                           details: "Method not implemented")
}
