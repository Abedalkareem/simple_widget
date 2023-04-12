import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'models/app_widget_data.dart';
import 'native_widget_method_channel.dart';

abstract class NativeWidgetPlatform extends PlatformInterface {
  /// Constructs a NativeWidgetPlatform.
  NativeWidgetPlatform() : super(token: _token);

  static final Object _token = Object();

  static NativeWidgetPlatform _instance = MethodChannelNativeWidget();

  /// The default instance of [NativeWidgetPlatform] to use.
  ///
  /// Defaults to [MethodChannelNativeWidget].
  static NativeWidgetPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [NativeWidgetPlatform] when
  /// they register themselves.
  static set instance(NativeWidgetPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Stream<Uri?> get widgetClicked {
    throw UnimplementedError('widgetClicked has not been implemented.');
  }

  Future updateWidgets(List<AppWidgetData> list) {
    throw UnimplementedError('updateWidgets() has not been implemented.');
  }

  Future refresh() async {
    throw UnimplementedError('refresh() has not been implemented.');
  }

  Future setGroupID(String groupID) async {
    throw UnimplementedError('setGroupID() has not been implemented.');
  }

  Future<String?> getLaunchedURL() async {
    throw UnimplementedError('getLaunchedURL() has not been implemented.');
  }

  Future setAppScheme(String appScheme) async {
    throw UnimplementedError('setAppScheme() has not been implemented.');
  }
}
