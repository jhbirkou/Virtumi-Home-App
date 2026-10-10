import 'package:flutter/widgets.dart';

/// Smart LED timed/automatic command (Sttrigger), index 0–9.
@immutable
class SmartLedTrigger {
  const SmartLedTrigger({
    required this.parameterIndex,
    this.id,
    this.active = 0,
    this.done = 0,
    this.changeSwitchState = 0,
    this.changeBrightness = 0,
    this.changeOffAutomatic = 0,
    this.lampOn = 0,
    this.offAutomatic = 0,
    this.changeLedEffect = 0,
    this.brightness = 0,
    this.effectNumber = 0,
    this.triggerType = 1,
    this.name = '',
    this.commandTimeHour = 0,
    this.commandTimeMinute = 0,
    this.commandTimeSecond = 0,
    this.offAutomaticTimeHour = 0,
    this.offAutomaticTimeMinute = 0,
    this.offAutomaticTimeSecond = 0,
    this.commandDateDay = 1,
    this.commandDateMonth = 1,
    this.commandDateYear = 2026,
  });

  final String? id;
  final int parameterIndex;
  final int active;
  final int done;
  final int changeSwitchState;
  final int changeBrightness;
  final int changeOffAutomatic;
  final int lampOn;
  final int offAutomatic;
  final int changeLedEffect;
  final int brightness;
  final int effectNumber;
  final int triggerType;
  final String name;
  final int commandTimeHour;
  final int commandTimeMinute;
  final int commandTimeSecond;
  final int offAutomaticTimeHour;
  final int offAutomaticTimeMinute;
  final int offAutomaticTimeSecond;
  final int commandDateDay;
  final int commandDateMonth;
  final int commandDateYear;

  String get commandTimeLabel => _formatTime(
        commandTimeHour,
        commandTimeMinute,
        commandTimeSecond,
      );

  String get offAutomaticTimeLabel => _formatTime(
        offAutomaticTimeHour,
        offAutomaticTimeMinute,
        offAutomaticTimeSecond,
      );

  String get commandDateLabel =>
      '${commandDateDay.toString().padLeft(2, '0')}.'
      '${commandDateMonth.toString().padLeft(2, '0')}.'
      '$commandDateYear';

  static String _formatTime(int hour, int minute, int second) =>
      '${hour.toString().padLeft(2, '0')}:'
      '${minute.toString().padLeft(2, '0')}:'
      '${second.toString().padLeft(2, '0')}';

  SmartLedTrigger copyWith({
    String? id,
    int? active,
    int? done,
    int? changeSwitchState,
    int? changeBrightness,
    int? changeOffAutomatic,
    int? lampOn,
    int? offAutomatic,
    int? changeLedEffect,
    int? brightness,
    int? effectNumber,
    int? triggerType,
    String? name,
    int? commandTimeHour,
    int? commandTimeMinute,
    int? commandTimeSecond,
    int? offAutomaticTimeHour,
    int? offAutomaticTimeMinute,
    int? offAutomaticTimeSecond,
    int? commandDateDay,
    int? commandDateMonth,
    int? commandDateYear,
  }) {
    return SmartLedTrigger(
      id: id ?? this.id,
      parameterIndex: parameterIndex,
      active: active ?? this.active,
      done: done ?? this.done,
      changeSwitchState: changeSwitchState ?? this.changeSwitchState,
      changeBrightness: changeBrightness ?? this.changeBrightness,
      changeOffAutomatic: changeOffAutomatic ?? this.changeOffAutomatic,
      lampOn: lampOn ?? this.lampOn,
      offAutomatic: offAutomatic ?? this.offAutomatic,
      changeLedEffect: changeLedEffect ?? this.changeLedEffect,
      brightness: brightness ?? this.brightness,
      effectNumber: effectNumber ?? this.effectNumber,
      triggerType: triggerType ?? this.triggerType,
      name: name ?? this.name,
      commandTimeHour: commandTimeHour ?? this.commandTimeHour,
      commandTimeMinute: commandTimeMinute ?? this.commandTimeMinute,
      commandTimeSecond: commandTimeSecond ?? this.commandTimeSecond,
      offAutomaticTimeHour:
          offAutomaticTimeHour ?? this.offAutomaticTimeHour,
      offAutomaticTimeMinute:
          offAutomaticTimeMinute ?? this.offAutomaticTimeMinute,
      offAutomaticTimeSecond:
          offAutomaticTimeSecond ?? this.offAutomaticTimeSecond,
      commandDateDay: commandDateDay ?? this.commandDateDay,
      commandDateMonth: commandDateMonth ?? this.commandDateMonth,
      commandDateYear: commandDateYear ?? this.commandDateYear,
    );
  }
}
