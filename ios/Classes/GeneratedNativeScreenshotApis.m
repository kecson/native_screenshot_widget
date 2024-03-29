// Autogenerated from Pigeon (v11.0.1), do not edit directly.
// See also: https://pub.dev/packages/pigeon

#import "GeneratedNativeScreenshotApis.h"

#if TARGET_OS_OSX
#import <FlutterMacOS/FlutterMacOS.h>
#else
#import <Flutter/Flutter.h>
#endif

#if !__has_feature(objc_arc)
#error File requires ARC to be enabled.
#endif

static NSArray *wrapResult(id result, FlutterError *error) {
  if (error) {
    return @[
      error.code ?: [NSNull null], error.message ?: [NSNull null], error.details ?: [NSNull null]
    ];
  }
  return @[ result ?: [NSNull null] ];
}
static id GetNullableObjectAtIndex(NSArray *array, NSInteger key) {
  id result = array[key];
  return (result == [NSNull null]) ? nil : result;
}

NSObject<FlutterMessageCodec> *ScreenshotHostApiGetCodec(void) {
  static FlutterStandardMessageCodec *sSharedObject = nil;
  sSharedObject = [FlutterStandardMessageCodec sharedInstance];
  return sSharedObject;
}

void ScreenshotHostApiSetup(id<FlutterBinaryMessenger> binaryMessenger, NSObject<ScreenshotHostApi> *api) {
  ///Take Screenshot
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.native_screenshot_widget.ScreenshotHostApi.takeScreenshot"
        binaryMessenger:binaryMessenger
        codec:ScreenshotHostApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(takeScreenshotWithCompletion:)], @"ScreenshotHostApi api (%@) doesn't respond to @selector(takeScreenshotWithCompletion:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        [api takeScreenshotWithCompletion:^(FlutterStandardTypedData *_Nullable output, FlutterError *_Nullable error) {
          callback(wrapResult(output, error));
        }];
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
}
