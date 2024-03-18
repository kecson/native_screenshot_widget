
package com.ks.native_screenshot_widget.native_screenshot_widget;

import android.app.Activity;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Rect;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;
import android.view.PixelCopy;
import android.view.SurfaceView;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.io.ByteArrayOutputStream;

import io.flutter.plugin.common.BinaryMessenger;
import kotlin.jvm.internal.Intrinsics;

public class NativeScreenshotApiImpl implements GeneratedNativeScreenshotApis.ScreenshotHostApi {
    public NativeScreenshotApiImpl(BinaryMessenger binaryMessenger, Activity activity) {
        this.binaryMessenger = binaryMessenger;
        this.activity = activity;
    }

    BinaryMessenger binaryMessenger;
    Activity activity;
    @Override
    public void takeScreenshot(@NonNull GeneratedNativeScreenshotApis.Result<byte[]> result) {
        if (activity != null) {
            Window window = activity.getWindow();
            View view = window.getDecorView();
            SurfaceView surfaceView = getSurfaceView(view.getRootView());
            if (surfaceView == null) {
                result.success(null);
                return;
            }

            final Bitmap bitmap;
            try {
                if (Build.VERSION.SDK_INT >= 26) {
                    Rect surfaceFrame = surfaceView.getHolder().getSurfaceFrame();
                    bitmap = Bitmap.createBitmap(surfaceFrame.width(), surfaceFrame.height(), Bitmap.Config.ARGB_8888);
                    PixelCopy.request(surfaceView, surfaceFrame, bitmap, (PixelCopy.OnPixelCopyFinishedListener) (it -> {
                        if (it == 0) {
                            takeScreenshotResult(bitmap, result);
                        } else {
                            result.error(new Exception("fail to take screenshot"));
                        }
                    }), new Handler(Looper.getMainLooper()));
                } else {
                    bitmap = Bitmap.createBitmap(view.getWidth(), view.getHeight(), Bitmap.Config.RGB_565);
                    Canvas canvas = new Canvas(bitmap);
                    view.draw(canvas);
                    canvas.setBitmap((Bitmap) null);
                    Intrinsics.checkNotNullExpressionValue(bitmap, "tBitmap");
                    takeScreenshotResult(bitmap, result);
                }

            } catch (Exception e) {
                Log.e("takeScreenshot", e.getMessage());
                result.error(e);
            }
        } else {
            result.success(null);
        }
    }
    private void takeScreenshotResult(Bitmap bitmap, GeneratedNativeScreenshotApis.Result<byte[]> result) {
        ByteArrayOutputStream stream = new ByteArrayOutputStream();
        bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream);
        byte[] imageInByte = stream.toByteArray();
        result.success(imageInByte);
    }
    @Nullable
    SurfaceView getSurfaceView(View view) {
        if (view == null) {
            return null;
        } else {
            final SurfaceView[] surfaceView = new SurfaceView[1];
            traverseView(view, new OnViewListener() {
                @Override
                public void onView(View view) {
                    if (view instanceof SurfaceView) {
                        surfaceView[0] = ((SurfaceView) view);
                    }
                }
            });
            return surfaceView[0];
        }

    }

    private void traverseView(View view, OnViewListener onViewListener) {
        onViewListener.onView(view);
        if (view instanceof ViewGroup) {
            int childCount = ((ViewGroup) view).getChildCount();
            for (int i = 0; i < childCount; i++) {
                View child = ((ViewGroup) view).getChildAt(i);
                traverseView(child, onViewListener);
            }
        }

    }

    public interface OnViewListener {
        void onView(View view);
    }
}

