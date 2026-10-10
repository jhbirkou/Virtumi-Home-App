import 'package:flutter/widgets.dart';

/// Operating mode of the device LED.
enum LedStatus {
  alwaysOff('Immer aus'),
  alwaysOn('Immer an'),
  scheduled('In bestimmter Zeit an'),
  sunBased('Sonnenauf-/-untergang');

  const LedStatus(this.label);
  final String label;
}

/// Recurrence pattern for the scheduled LED window.
enum CommandType {
  everyday('Jeden Tag'),
  weekdays('Montag bis Freitag'),
  weekend('Nur Wochenende'),
  specificDay('Bestimmter Tag');

  const CommandType(this.label);
  final String label;
}

/// General device settings: LED color, brightness and on/off behaviour
/// (including an optional time schedule).
@immutable
class GeneralConfig {
  const GeneralConfig({
    this.ledColorValue = 0xFF0070EA,
    this.brightness = 80,
    this.ledStatus = LedStatus.alwaysOn,
    this.commandType = CommandType.everyday,
    this.startTime = '18:00',
    this.endTime = '23:00',
    this.specificDate,
  });

  /// LED color as a 32-bit ARGB value (use `Color(ledColorValue)` in the UI).
  final int ledColorValue;

  /// Brightness in percent (1-100).
  final int brightness;

  final LedStatus ledStatus;
  final CommandType commandType;

  /// Start / end of the scheduled "on" window ("HH:mm").
  final String startTime;
  final String endTime;

  /// Specific date ("dd.MM.yyyy"), only relevant for [CommandType.specificDay].
  final String? specificDate;

  GeneralConfig copyWith({
    int? ledColorValue,
    int? brightness,
    LedStatus? ledStatus,
    CommandType? commandType,
    String? startTime,
    String? endTime,
    String? specificDate,
  }) {
    return GeneralConfig(
      ledColorValue: ledColorValue ?? this.ledColorValue,
      brightness: brightness ?? this.brightness,
      ledStatus: ledStatus ?? this.ledStatus,
      commandType: commandType ?? this.commandType,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      specificDate: specificDate ?? this.specificDate,
    );
  }
}
