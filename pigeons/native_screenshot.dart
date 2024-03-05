import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/native_screenshot.g.dart',
    javaOut:
        'android/src/main/java/com/ks/native_screenshot_widget/native_screenshot_widget/GeneratedNativeScreenshotApis.java',
    javaOptions: JavaOptions(
      package: 'com.ks.native_screenshot_widget.native_screenshot_widget',
      className: 'GeneratedNativeScreenshotApis',
    ),
    objcHeaderOut: 'ios/Classes/GeneratedNativeScreenshotApis.h',
    objcSourceOut: 'ios/Classes/GeneratedNativeScreenshotApis.m',
    objcOptions: ObjcOptions(
      headerIncludePath: 'ios/Classes/GeneratedNativeScreenshotApis.h',
    ),
  ),
)

/// Flutter call Native
@HostApi()
abstract class ScreenshotHostApi {
  ///Take Screenshot
  @async
  Uint8List? takeScreenshot();
}
