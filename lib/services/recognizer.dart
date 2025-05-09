import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tflite_v2/tflite_v2.dart';

import '../utils/constants.dart';

final _canvasCullRect = Rect.fromPoints(
    const Offset(0, 0), Offset(Constants.imageSize, Constants.imageSize));

final _whitePaint = Paint()
  ..strokeCap = StrokeCap.round
  ..color = Colors.black
  ..strokeWidth = Constants.strokeWidth;

final _bgPaint = Paint()..color = Colors.white;

class Recognizer {
  Future loadModel() {
    Tflite.close();
    return Tflite.loadModel(
      model: "assets/baybayin_model2.tflite",
      labels: "assets/labels.txt",
      isAsset: true,
      numThreads: 1,
    );
  }

  dispose() {
    Tflite.close();
  }

  Future<Uint8List> previewImage(List<Offset?> points) async {
    final picture = _pointsToPicture(points);
    final image = await picture.toImage(
        Constants.baybayinImageSize, Constants.baybayinImageSize);
    var pngBytes = await image.toByteData(format: ImageByteFormat.png);

    return pngBytes!.buffer.asUint8List();
  }

  Future recognize(List<Offset?> points) async {
    final picture = _pointsToPicture(points);
    Uint8List bytes =
        await _imageToByteListUint8(picture, Constants.baybayinImageSize);
    return _predict(bytes);
  }

  Future _predict(Uint8List bytes) async {
    return Tflite.runModelOnBinary(binary: bytes, numResults: 63);
  }

  Picture _pointsToPicture(List<Offset?> points) {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder, _canvasCullRect)
      ..scale(Constants.baybayinImageSize / Constants.canvasSize);

    canvas.drawRect(
        Rect.fromLTWH(0, 0, Constants.imageSize, Constants.imageSize),
        _bgPaint);

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, _whitePaint);
      }
    }
    return recorder.endRecording();
  }

  Future<Uint8List> _imageToByteListUint8(Picture pic, int size) async {
    final img = await pic.toImage(size, size);
    final imgBytes = await img.toByteData();
    final resultBytes = Float32List(size * size);
    final buffer = Float32List.view(resultBytes.buffer);

    int index = 0;

    for (int i = 0; i < imgBytes!.lengthInBytes; i += 4) {
      final r = imgBytes.getUint8(i);
      final g = imgBytes.getUint8(i + 1);
      final b = imgBytes.getUint8(i + 2);

      buffer[index++] = (r + g + b) / 3 / 255.0;
    }

    return resultBytes.buffer.asUint8List();
  }
}
