#import "NativeScreenshotWidgetPlugin.h"

@implementation NativeScreenshotWidgetPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    NativeScreenshotWidgetPlugin* instance = [[NativeScreenshotWidgetPlugin alloc] init];
    ScreenshotHostApiSetup(registrar.messenger, instance);
}


- (void)takeScreenshotWithCompletion:(nonnull void (^)(FlutterStandardTypedData * _Nullable, FlutterError * _Nullable))completion {
    @try {
        UIApplication *app=  [UIApplication sharedApplication];
        UIView *view= [[[[app delegate] window] rootViewController] view];
        
        UIGraphicsBeginImageContextWithOptions([view bounds].size,[view isOpaque],[UIScreen mainScreen].scale);
        
        [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:TRUE];
        
        UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        NSData *imageData= UIImageJPEGRepresentation(image, 1.0f);
        FlutterStandardTypedData *data  = [FlutterStandardTypedData typedDataWithBytes:imageData];
        completion(data,nil);
    } @catch (NSException *exception) {
        // takeSnapshot error
        FlutterError * flutterError = nil;
        flutterError = [FlutterError errorWithCode:@"TakeScreenshotError"
                                           message:@"Failed takeScreenshot."
                                           details:exception.description];
        NSLog(@"%@",exception);
        completion(nil,flutterError);
    } @finally {
        
    }
}

@end
