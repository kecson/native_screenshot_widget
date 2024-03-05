import 'dart:typed_data';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'native_screenshot_widget_method_channel.dart';

abstract class NativeScreenshotWidgetPlatform extends PlatformInterface {
  /// Constructs a NativeScreenshotWidgetPlatform.
  NativeScreenshotWidgetPlatform() : super(token: _token);

  static final Object _token = Object();

  static NativeScreenshotWidgetPlatform _instance =
      MethodChannelNativeScreenshot();

  /// The default instance of [NativeScreenshotWidgetPlatform] to use.
  ///
  /// Defaults to [MethodChannelNativeScreenshot].
  static NativeScreenshotWidgetPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [NativeScreenshotWidgetPlatform] when
  /// they register themselves.
  static set instance(NativeScreenshotWidgetPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<Uint8List?> takeScreenshot() {
    throw UnimplementedError('Uint8List() has not been implemented.');
  }
}
