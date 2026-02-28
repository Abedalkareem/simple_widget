import 'dart:typed_data';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'models/timeline.dart';
import 'simple_widget_method_channel.dart';

abstract class SimpleWidgetPlatform extends PlatformInterface {
  /// Constructs a SimpleWidgetPlatform.
  SimpleWidgetPlatform() : super(token: _token);

  static final Object _token = Object();

  static SimpleWidgetPlatform _instance = MethodChannelSimpleWidget();

  /// The default instance of [SimpleWidgetPlatform] to use.
  ///
  /// Defaults to [MethodChannelSimpleWidget].
  static SimpleWidgetPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SimpleWidgetPlatform] when
  /// they register themselves.
  static set instance(SimpleWidgetPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Stream<Uri?> get widgetClicked {
    throw UnimplementedError('widgetClicked has not been implemented.');
  }

  Future updateWidgets(List<TimeLine> list) {
    throw UnimplementedError('updateWidgets() has not been implemented.');
  }

  Future<List<TimeLine>> getTimelinesData() {
    throw UnimplementedError('updateWidgets() has not been implemented.');
  }

  Future refresh() async {
    throw UnimplementedError('refresh() has not been implemented.');
  }

  Future setGroupID(String groupID) async {
    throw UnimplementedError('setGroupID() has not been implemented.');
  }

  Future<Uri?> getLaunchedURL() async {
    throw UnimplementedError('getLaunchedURL() has not been implemented.');
  }

  Future setAppScheme(String appScheme) async {
    throw UnimplementedError('setAppScheme() has not been implemented.');
  }

  Future<String> saveImageFile(Uint8List bytes, {String? filename}) {
    throw UnimplementedError('saveImageFile() has not been implemented.');
  }

  Future<void> deleteImageFiles(List<String> relativePaths) {
    throw UnimplementedError('deleteImageFiles() has not been implemented.');
  }

  Future<bool> migrateToFileStorage() {
    throw UnimplementedError('migrateToFileStorage() has not been implemented.');
  }

  Future<String> getImageBasePath() {
    throw UnimplementedError('getImageBasePath() has not been implemented.');
  }
}
