import 'dart:io';
import 'dart:math' as math;

import 'package:image/image.dart' as img;

/// Composites the logo onto the app background as a fully opaque launcher icon.
void main() {
  const size = 1024;
  final background = img.ColorRgba8(242, 251, 252, 255); // AppColors.background

  final sourceBytes = File('assets/images/app_icon.png').readAsBytesSync();
  final source = img.decodeImage(sourceBytes);
  if (source == null) {
    stderr.writeln('Could not decode assets/images/app_icon.png');
    exit(1);
  }

  final launcher = _compose(
    source: source,
    size: size,
    background: background,
    maxSide: size * 0.78,
  );

  final output = File('assets/images/app_icon_launcher.png');
  output.writeAsBytesSync(img.encodePng(launcher));
  stdout.writeln('Wrote ${output.path}');

  // Android 12+ masks the splash icon to a 160dp circle inside a 240dp slot.
  // Scale down so the full logo (badge + wordmark) stays inside that circle.
  const splashCircleFraction = 160 / 240;
  final splashMaxSide = size * splashCircleFraction * 0.9;
  final splash = _compose(
    source: source,
    size: size,
    background: background,
    maxSide: splashMaxSide,
  );

  const splashDir = 'android/app/src/main/res/drawable-nodpi';
  Directory(splashDir).createSync(recursive: true);
  final splashOutput = File('$splashDir/splash_icon.png');
  splashOutput.writeAsBytesSync(img.encodePng(splash));
  stdout.writeln('Wrote ${splashOutput.path}');
}

img.Image _compose({
  required img.Image source,
  required int size,
  required img.ColorRgba8 background,
  required double maxSide,
}) {
  final canvas = img.Image(width: size, height: size, numChannels: 4);
  img.fill(canvas, color: background);

  final scale = maxSide /
      math.max(source.width.toDouble(), source.height.toDouble());
  final targetWidth = (source.width * scale).round();
  final targetHeight = (source.height * scale).round();
  final resized = img.copyResize(
    source,
    width: targetWidth,
    height: targetHeight,
    interpolation: img.Interpolation.cubic,
  );

  img.compositeImage(
    canvas,
    resized,
    dstX: (size - targetWidth) ~/ 2,
    dstY: (size - targetHeight) ~/ 2,
  );

  final opaque = img.Image(width: size, height: size, numChannels: 3);
  img.compositeImage(opaque, canvas);
  return opaque;
}
