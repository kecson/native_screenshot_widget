import 'dart:typed_data';
import 'dart:ui';

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

  Future<Uint8List?> takeScreenshot() async {
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
          size.width * _devicePixelRatio,
          size.height * _devicePixelRatio,
        );
        final src = Rect.fromLTWH(
          offset.dx * _devicePixelRatio,
          offset.dy * _devicePixelRatio,
          size.width * _devicePixelRatio,
          size.height * _devicePixelRatio,
        );
        final PictureRecorder pictureRecorder = PictureRecorder();
        final Canvas canvas = Canvas(pictureRecorder, dst);
        canvas.drawImageRect(image, src, dst, Paint());
        final clipImage = pictureRecorder.endRecording().toImageSync(
              src.width.toInt(),
              src.height.toInt(),
            );

        return clipImage
            .toByteData(format: ImageByteFormat.png)
            .then((value) => value?.buffer.asUint8List());
      }

      return null;
    });
  }
}
