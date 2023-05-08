import 'models/timeline.dart';
import 'simple_widget_platform_interface.dart';

export 'util/widget_to_image.dart';
export 'models/app_widget_data.dart';
export 'models/timeline.dart';

class SimpleWidget {
  /// Listen to the widget clicked events.
  /// The value is the url that the widget clicked on with it's `id`.
  Stream<Uri?> get widgetClicked {
    return SimpleWidgetPlatform.instance.widgetClicked;
  }

  /// Update the timelines with the given list.
  Future updateWidgets(List<TimeLine> list) {
    return SimpleWidgetPlatform.instance.updateWidgets(list);
  }

  /// Get all the [TimeLine].
  Future<List<TimeLine>> getTimelinesData() {
    return SimpleWidgetPlatform.instance.getTimelinesData();
  }

  /// Refresh all the widgets.
  Future refresh() {
    return SimpleWidgetPlatform.instance.refresh();
  }

  /// Set the group id of the app.
  /// This is available in the `App Groups` in the `Signing & Capabilities` tab in Xcode.
  /// You should also set the same group id on the native size `Settings` class.
  /// **Note**: This is required just on iOS.
  Future setGroupID(String groupID) async {
    await SimpleWidgetPlatform.instance.setGroupID(groupID);
  }

  /// Get the url that the app launched with.
  Future<Uri?> getLaunchedURL() async {
    return await SimpleWidgetPlatform.instance.getLaunchedURL();
  }

  /// Set the app scheme.
  /// You should also set the same scheme on the native side `Settings` class.
  Future setAppScheme(String appScheme) async {
    await SimpleWidgetPlatform.instance.setAppScheme(appScheme);
  }
}
