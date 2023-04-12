class AppWidgetData {
  final String id;
  final String background;
  final String foreground;

  AppWidgetData(this.id, this.background, this.foreground);

  factory AppWidgetData.fromJson(Map json) {
    return AppWidgetData(json["id"], json["background"], json["foreground"]);
  }

  Map toJson() => {
        "id": id,
        "background": background,
        "foreground": foreground,
      };
}
