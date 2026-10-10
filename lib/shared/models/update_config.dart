import 'package:flutter/widgets.dart';

/// When automatic updates should run.
enum UpdateSchedule {
  everyDay('Jeden Tag'),
  weekdays('Montag bis Freitag'),
  weekend('Nur Wochenende'),
  specificDay('Bestimmten Tag');

  const UpdateSchedule(this.label);
  final String label;
}

/// Weekday used when [UpdateSchedule.specificDay] is selected.
enum Weekday {
  monday('Montag'),
  tuesday('Dienstag'),
  wednesday('Mittwoch'),
  thursday('Donnerstag'),
  friday('Freitag'),
  saturday('Samstag'),
  sunday('Sonntag');

  const Weekday(this.label);
  final String label;
}

/// Firmware/OS update configuration & status for a device.
@immutable
class UpdateConfig {
  const UpdateConfig({
    this.osName = 'Aura OS',
    this.currentVersion = 'v2.4.1',
    this.availableVersion = 'v2.5.0',
    this.updateAvailable = true,
    this.description =
        'Ein neues System-Update steht zur Verfügung. Es enthält Fehlerbehebungen und Leistungsverbesserungen.',
    this.autoUpdatesEnabled = true,
    this.updateSchedule = UpdateSchedule.everyDay,
    this.weekday = Weekday.monday,
    this.scheduledTime = '23:50:00',
  });

  final String osName;
  final String currentVersion;
  final String availableVersion;
  final bool updateAvailable;
  final String description;
  final bool autoUpdatesEnabled;
  final UpdateSchedule updateSchedule;
  final Weekday weekday;

  /// Scheduled update time in "HH:mm:ss" format.
  final String scheduledTime;

  UpdateConfig copyWith({
    String? osName,
    String? currentVersion,
    String? availableVersion,
    bool? updateAvailable,
    String? description,
    bool? autoUpdatesEnabled,
    UpdateSchedule? updateSchedule,
    Weekday? weekday,
    String? scheduledTime,
  }) {
    return UpdateConfig(
      osName: osName ?? this.osName,
      currentVersion: currentVersion ?? this.currentVersion,
      availableVersion: availableVersion ?? this.availableVersion,
      updateAvailable: updateAvailable ?? this.updateAvailable,
      description: description ?? this.description,
      autoUpdatesEnabled: autoUpdatesEnabled ?? this.autoUpdatesEnabled,
      updateSchedule: updateSchedule ?? this.updateSchedule,
      weekday: weekday ?? this.weekday,
      scheduledTime: scheduledTime ?? this.scheduledTime,
    );
  }
}
