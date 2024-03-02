import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:ff_native_screenshot/ff_native_screenshot.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class NativeScreenshot extends SingleChildRenderObjectWidget {
  const NativeScreenshot({
    Key? key,
    required Widget child,
    this.controller,
  }) : super(key: key, child: child);
  final NativeScreenshotController? controller;

  @override
  RenderProxyBox createRenderObject(BuildContext context) {
    var proxyBox = RenderProxyBox();
    controller?._renderObject = proxyBox;
    controller?._devicePixelRatio = View.of(context).devicePixelRatio;
    return proxyBox;
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderProxyBox renderObject,
  ) {
    super.updateRenderObject(context, renderObject);
    controller?._renderObject = renderObject;
    controller?._devicePixelRatio = View.of(context).devicePixelRatio;
  }
}

class NativeScreenshotController {
  RenderBox? _renderObject;
  double _devicePixelRatio = 1.0;

  Future<Uint8List?> takeScreenshot({double scale = 1.0}) {
    return takeScreenshotImage(scale: scale)
        .then((image) => image?.toPngBytes());
  }

  Future<ui.Image?> takeScreenshotImage({double scale = 1.0}) async {
    if (_renderObject == null ||
        _renderObject?.hasSize != true ||
        _renderObject?.attached != true) {
      return null;
    }

    final offset = _renderObject!.localToGlobal(Offset.zero);
    final size = _renderObject!.size;
    return FfNativeScreenshot().takeScreenshot().then((bytes) async {
      if (bytes != null) {
        final image = await decodeImageFromList(bytes);
        final dst = Rect.fromLTWH(
          0,
          0,
          size.width * _devicePixelRatio * scale,
          size.height * _devicePixelRatio * scale,
        );
        final src = Rect.fromLTWH(
          offset.dx * _devicePixelRatio,
          offset.dy * _devicePixelRatio,
          size.width * _devicePixelRatio,
          size.height * _devicePixelRatio,
        );
        final pictureRecorder = ui.PictureRecorder();
        final canvas = Canvas(pictureRecorder, dst);
        canvas.drawImageRect(image, src, dst, Paint());
        final renderObjectImage = pictureRecorder.endRecording().toImageSync(
              dst.width.toInt(),
              dst.height.toInt(),
            );
        return renderObjectImage;
      }

      return null;
    });
  }
}

extension NativeScreenshotImageScale on ui.Image {
  Future<ui.Image?> scaleImage(double scale) async {
    if (scale == 1.0) return this;
    final bytes = await toPngBytes();
    if (bytes == null) return null;
    final codec = await ui.instantiateImageCodec(
      bytes,
      targetWidth: (width * scale).toInt(),
      targetHeight: (height * scale).toInt(),
    );
    final frameInfo = await codec.getNextFrame();
    final scaleImage = frameInfo.image;
    return scaleImage;
  }

  Future<Uint8List?> toPngBytes() {
    return toByteData(format: ui.ImageByteFormat.png)
        .then((value) => value?.buffer.asUint8List());
  }
}
