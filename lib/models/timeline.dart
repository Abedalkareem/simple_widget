import 'package:native_widget/models/app_widget_data.dart';

class TimeLine {
  final String type;
  final String id;
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
