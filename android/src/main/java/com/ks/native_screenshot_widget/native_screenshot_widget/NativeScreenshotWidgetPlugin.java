package com.ks.native_screenshot_widget.native_screenshot_widget;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;

/**
 * NativeScreenshotWidgetPlugin
 */
public class NativeScreenshotWidgetPlugin implements FlutterPlugin, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private FlutterPluginBinding pluginBinding;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        pluginBinding = flutterPluginBinding;
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {

    }


    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        BinaryMessenger binaryMessenger = pluginBinding.getBinaryMessenger();
        NativeScreenshotApiImpl screenshotApi = new NativeScreenshotApiImpl(binaryMessenger, binding.getActivity());
        GeneratedNativeScreenshotApis.ScreenshotHostApi.setup(binaryMessenger, screenshotApi);
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {

    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {

    }

    @Override
    public void onDetachedFromActivity() {

    }
}
