import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'models/app_widget_data.dart';
import 'native_widget_platform_interface.dart';

/// An implementation of [NativeWidgetPlatform] that uses method channels.
class MethodChannelNativeWidget extends NativeWidgetPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('native_widget');
  static const EventChannel _eventChannel =
      EventChannel("native_widget/events");

  @override
  Stream<Uri?> get widgetClicked {
    return _eventChannel
        .receiveBroadcastStream()
        .map<Uri?>((value) => Uri.tryParse(value));
  }

  @override
  Future updateWidgets(List<AppWidgetData> list) async {
    final data = jsonEncode(list.map((item) => item.toJson()).toList());
    final version = await methodChannel.invokeMethod("updateWidgets", data);
    return version;
  }

  @override
  Future refresh() async {
    final version = await methodChannel.invokeMethod("refreshWidgets");
    return version;
  }

  @override
  Future setGroupID(String groupID) async {
    await methodChannel.invokeMethod("setGroupID", groupID);
  }

  @override
  Future<String?> getLaunchedURL() async {
    return await methodChannel.invokeMethod("getLaunchedURL");
  }

  @override
  Future setAppScheme(String appScheme) async {
    await methodChannel.invokeMethod("setAppScheme", appScheme);
  }
}
