class AppWidgetData {
  final int date;
  final String id;
  final String background;
  final String foreground;

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
