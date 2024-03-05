// Autogenerated from Pigeon (v11.0.1), do not edit directly.
// See also: https://pub.dev/packages/pigeon

#import <Foundation/Foundation.h>

@protocol FlutterBinaryMessenger;
@protocol FlutterMessageCodec;
@class FlutterError;
@class FlutterStandardTypedData;

NS_ASSUME_NONNULL_BEGIN


/// The codec used by ScreenshotHostApi.
NSObject<FlutterMessageCodec> *ScreenshotHostApiGetCodec(void);

/// Flutter call Native
@protocol ScreenshotHostApi
///Take Screenshot
- (void)takeScreenshotWithCompletion:(void (^)(FlutterStandardTypedData *_Nullable, FlutterError *_Nullable))completion;
@end

extern void ScreenshotHostApiSetup(id<FlutterBinaryMessenger> binaryMessenger, NSObject<ScreenshotHostApi> *_Nullable api);

NS_ASSUME_NONNULL_END