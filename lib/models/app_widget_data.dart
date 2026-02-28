/// A data that represents a widget in a spesific time.
class AppWidgetData {
  /// The date when the widget should be shown
  /// the time in milliseconds since epoch.
  final int date;

  /// Id of the timeline that this widget belongs to.
  /// You will get this id when the user click on the home screen widget
  String id;

  /// A relative image path that represents the background of the widget.
  final String background;

  /// A relative image path that represents the foreground of the widget.
  final String foreground;

  /// A data that represents a widget in a spesific time.
  AppWidgetData(this.date, this.id, this.background, this.foreground);

  factory AppWidgetData.fromJson(Map json) {
    return AppWidgetData(
      json["date"],
      json["id"],
      json["background"],
      json["foreground"],
    );
  }

  Map toJson() => {
        "date": date,
        "id": id,
        "background": background,
        "foreground": foreground,
      };
}
