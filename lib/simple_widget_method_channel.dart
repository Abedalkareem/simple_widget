import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'models/timeline.dart';
import 'simple_widget_platform_interface.dart';

/// An implementation of [SimpleWidgetPlatform] that uses method channels.
class MethodChannelSimpleWidget extends SimpleWidgetPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('simple_widget');
  static const EventChannel _eventChannel =
      EventChannel("simple_widget/events");

  @override
  Stream<Uri?> get widgetClicked {
    return _eventChannel
        .receiveBroadcastStream()
        .map<Uri?>((value) => Uri.tryParse(value));
  }

  @override
  Future updateWidgets(List<TimeLine> list) async {
    final data = jsonEncode(list.map((item) => item.toJson()).toList());
    final version = await methodChannel.invokeMethod("updateWidgets", data);
    return version;
  }

  @override
  Future<List<TimeLine>> getTimelinesData() async {
    final result = await methodChannel.invokeMethod("getTimelinesData");
    if (result == null) {
      return [];
    }
    final List jsonArray = jsonDecode(result);
    final timelines = jsonArray.map((json) => TimeLine.fromJson(json)).toList();
    return timelines;
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
  Future<Uri?> getLaunchedURL() async {
    final link = await methodChannel.invokeMethod("getLaunchedURL") ?? "";
    return Uri.tryParse(link);
  }

  @override
  Future setAppScheme(String appScheme) async {
    await methodChannel.invokeMethod("setAppScheme", appScheme);
  }
}
