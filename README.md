# native_screenshot_widget

[![pub package](https://img.shields.io/pub/v/native_screenshot_widget.svg)](https://pub.dev/packages/native_screenshot_widget) | [![pub points](https://img.shields.io/pub/points/native_screenshot_widget)](https://pub.dev/packages/native_screenshot_widget/score) | [![popularity](https://img.shields.io/pub/popularity/native_screenshot_widget)](https://pub.dev/packages/native_screenshot_widget/score)

## Using

```dart 
//PlatformView: e.g: WebView
final screenshotController = NativeScreenshotController();

NativeScreenshot(
controller: screenshotController,
child: WebViewWidget(
controller: WebViewController()
..loadRequest(Uri.parse('https://flutter.dev')),
),
);


//take screenshot:
final imageBytes = await screenshotController.takeScreenshot();
```

```dart
//Flutter Widget
final screenshotController = NativeScreenshotController();

NativeScreenshot(
controller: screenshotController,
child: Text(
"Flutter Widget",
style: Theme.of(context).textTheme.titleLarge,
),
),
//take screenshot:
final imageBytes = await screenshotController.takeScreenshot();

```