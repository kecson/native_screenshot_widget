import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'native_screenshot_widget.dart';
import 'native_screenshot_widget_platform_interface.dart';

/// An implementation of [NativeScreenshotWidgetPlatform] that uses method channels.
class MethodChannelNativeScreenshot extends NativeScreenshotWidgetPlatform {
  /// The method channel used to interact with the native platform.
  final _hostApi = ScreenshotHostApi();

  @override
  Future<Uint8List?> takeScreenshot() {
    return _hostApi.takeScreenshot();
  }
}
