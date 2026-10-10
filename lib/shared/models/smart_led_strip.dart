import 'package:flutter/widgets.dart';

/// Single LED strip configuration (index 1–3).
@immutable
class SmartLedStrip {
  const SmartLedStrip({
    required this.ledIndex,
    this.ledCount = 1,
    this.rgbColorR = 0,
    this.rgbColorG = 0,
    this.rgbColorB = 0,
    this.rgbColorR2 = 0,
    this.rgbColorG2 = 0,
    this.rgbColorB2 = 0,
    this.speed = 0,
    this.effectNumber = 0,
    this.ledOn = 0,
    this.available = 0,
    this.autoMode = 0,
    this.autoModeTime = 0,
    this.ledFunctionNr = 0,
    this.brightness = 10,
    this.offAutomatic = 0,
    this.maxBrightness = 100,
    this.offTime = '',
  });

  final int ledIndex;
  final int ledCount;
  final int rgbColorR;
  final int rgbColorG;
  final int rgbColorB;
  final int rgbColorR2;
  final int rgbColorG2;
  final int rgbColorB2;
  final int speed;
  final int effectNumber;
  final int ledOn;
  final int available;
  final int autoMode;
  final int autoModeTime;
  final int ledFunctionNr;
  final int brightness;
  final int offAutomatic;
  final int maxBrightness;
  final String offTime;

  int get ledColorValue =>
      0xFF000000 | (rgbColorR << 16) | (rgbColorG << 8) | rgbColorB;

  int get ledColorValue2 =>
      0xFF000000 | (rgbColorR2 << 16) | (rgbColorG2 << 8) | rgbColorB2;

  SmartLedStrip copyWith({
    int? ledCount,
    int? rgbColorR,
    int? rgbColorG,
    int? rgbColorB,
    int? rgbColorR2,
    int? rgbColorG2,
    int? rgbColorB2,
    int? speed,
    int? effectNumber,
    int? ledOn,
    int? available,
    int? autoMode,
    int? autoModeTime,
    int? ledFunctionNr,
    int? brightness,
    int? offAutomatic,
    int? maxBrightness,
    String? offTime,
    int? ledColorValue,
    int? ledColorValue2,
  }) {
    var r = rgbColorR ?? this.rgbColorR;
    var g = rgbColorG ?? this.rgbColorG;
    var b = rgbColorB ?? this.rgbColorB;
    var r2 = rgbColorR2 ?? this.rgbColorR2;
    var g2 = rgbColorG2 ?? this.rgbColorG2;
    var b2 = rgbColorB2 ?? this.rgbColorB2;
    if (ledColorValue != null) {
      r = (ledColorValue >> 16) & 0xFF;
      g = (ledColorValue >> 8) & 0xFF;
      b = ledColorValue & 0xFF;
    }
    if (ledColorValue2 != null) {
      r2 = (ledColorValue2 >> 16) & 0xFF;
      g2 = (ledColorValue2 >> 8) & 0xFF;
      b2 = ledColorValue2 & 0xFF;
    }
    return SmartLedStrip(
      ledIndex: ledIndex,
      ledCount: ledCount ?? this.ledCount,
      rgbColorR: r,
      rgbColorG: g,
      rgbColorB: b,
      rgbColorR2: r2,
      rgbColorG2: g2,
      rgbColorB2: b2,
      speed: speed ?? this.speed,
      effectNumber: effectNumber ?? this.effectNumber,
      ledOn: ledOn ?? this.ledOn,
      available: available ?? this.available,
      autoMode: autoMode ?? this.autoMode,
      autoModeTime: autoModeTime ?? this.autoModeTime,
      ledFunctionNr: ledFunctionNr ?? this.ledFunctionNr,
      brightness: brightness ?? this.brightness,
      offAutomatic: offAutomatic ?? this.offAutomatic,
      maxBrightness: maxBrightness ?? this.maxBrightness,
      offTime: offTime ?? this.offTime,
    );
  }
}
