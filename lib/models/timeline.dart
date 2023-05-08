import 'package:simple_widget/models/app_widget_data.dart';

/// A data that represents a timeline of widgets.
class TimeLine {
  /// This will be shown on the iOS when the user long press on the widget.
  final String type;

  /// Id of the timeline.
  String id;

  /// A list of widgets that will be shown on the timeline.
  /// At least one widget must have the time of the current time.
  final List<AppWidgetData> data;

  TimeLine({
    required this.type,
    required this.id,
    required this.data,
  });

  factory TimeLine.fromJson(Map json) {
    return TimeLine(
      type: json["type"],
      id: json["id"],
      data: (json["data"] as List?)
              ?.map((item) => AppWidgetData.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map toJson() => {
        "type": type,
        "id": id,
        "data": data.map((item) => item.toJson()).toList(),
      };
}
