import '../../../models/device_settings.dart';
import '../../../models/general_config.dart';
import '../../../models/update_config.dart';

DateTimeConfig mapDateTimeConfig(Map<String, dynamic>? row) {
  if (row == null) return const DateTimeConfig();

  final city = row['city'] as String?;
  final country = row['country'] as String?;
  final label = [city, country].where((e) => e != null && e.isNotEmpty).join(', ');

  final date = row['date'] as String?;
  final time = row['time'] as String?;
  final ntpActive = row['ntp_server_active'];
  final automatic = ntpActive is bool
      ? ntpActive
      : intToBool(ntpActive is int ? ntpActive : int.tryParse('$ntpActive'));

  return DateTimeConfig(
    automatic: automatic,
    timezone: label.isNotEmpty
        ? label
        : (row['timezonename'] as String? ??
            row['timezone'] as String? ??
            'Berlin, Deutschland'),
    timezoneTz: row['timezone'] as String? ?? 'CET-1CEST,M3.5.0,M10.5.0/3',
    ntpServer: row['ntp_server'] as String? ?? 'pool.ntp.org',
    secondaryNtpServer: row['ntp_server_2'] as String? ?? '',
    manualDate: date ?? '',
    manualTime: time != null && time.length >= 5 ? time.substring(0, 5) : '',
  );
}

/// Maps a UDP protocol-12 read response to [UpdateConfig].
UpdateConfig mapUpdateConfigFromUdp(Map<String, dynamic>? json) {
  if (json == null) return const UpdateConfig();

  final rawVersion = json['current_version']?.toString() ?? '1.0';
  final version = rawVersion.startsWith('v') ? rawVersion : 'v$rawVersion';

  return UpdateConfig(
    currentVersion: version,
    availableVersion: version,
    updateAvailable: false,
    description: 'Dein System ist auf dem neuesten Stand.',
    autoUpdatesEnabled: intToBool(json['active'] as int?),
    updateSchedule: scheduleFromMode(json['mode'] as int?),
    weekday: weekdayFromDay(json['day'] as int?),
    scheduledTime: json['time'] as String? ?? '00:00:00',
  );
}

DeviceLocation deviceLocationDefaults({
  required String deviceName,
  String home = 'Mein Zuhause',
  String floor = 'Erdgeschoss',
  String room = 'Wohnzimmer',
}) {
  return DeviceLocation(
    deviceName: deviceName,
    houseName: home,
    floorName: floor,
    roomName: room,
  );
}

Map<String, dynamic> deviceLocationUdpWritePayload(
  String deviceCode,
  DeviceLocation location,
) {
  return {
    'protocol_nr': 14,
    'reply_protocol': 14,
    'code': deviceCode,
    'name': location.deviceName,
    'home': location.houseName,
    'floor': location.floorName,
    'room': location.roomName,
  };
}

Map<String, dynamic> dateTimeUdpWritePayload(
  String deviceCode,
  DateTimeConfig config,
) {
  final manualDate = config.manualDate.isNotEmpty
      ? config.manualDate
      : DateTime.now().toIso8601String().split('T').first;
  final manualTime = config.manualTime.isNotEmpty
      ? '${config.manualTime}:00'.replaceFirst(RegExp(r':00:00$'), ':00')
      : DateTime.now().toIso8601String().split('T').last.split('.').first;

  return {
    'protocol_nr': 5,
    'reply_protocol': 5,
    'code': deviceCode,
    'ntp_server_active': config.automatic,
    'time_change_active': !config.automatic,
    'ntp_server': config.ntpServer,
    'ntp_server_2': config.secondaryNtpServer,
    'timezone': config.timezoneTz,
    'date': manualDate,
    'time': manualTime,
  };
}

Map<String, dynamic> generalUdpWritePayload(
  String deviceCode,
  GeneralConfig config,
) {
  final color = config.ledColorValue;
  return {
    'protocol_nr': 6,
    'reply_protocol': 6,
    'code': deviceCode,
    'mode': commandTypeToMode(config.commandType),
    'led_state': ledStateToInt(config.ledStatus),
    'rgb_color_r': (color >> 16) & 0xFF,
    'rgb_color_g': (color >> 8) & 0xFF,
    'rgb_color_b': color & 0xFF,
    'brightness': config.brightness,
    'cmd_date': config.specificDate ??
        DateTime.now().toIso8601String().split('T').first,
    'cmd_start': '${config.startTime}:00',
    'cmd_end': '${config.endTime}:00',
  };
}

Map<String, dynamic> updateUdpWritePayload(
  String deviceCode,
  UpdateConfig config,
) {
  return {
    'protocol_nr': 12,
    'reply_protocol': 12,
    'code': deviceCode,
    'command': 1,
    'active': boolToInt(config.autoUpdatesEnabled),
    'mode': scheduleToMode(config.updateSchedule),
    'day': config.updateSchedule == UpdateSchedule.specificDay
        ? weekdayToDay(config.weekday)
        : 1,
    'time': config.scheduledTime,
  };
}

Map<String, dynamic> dateTimePayload(
  String deviceId,
  String userId,
  DateTimeConfig config,
) {
  return {
    'device_id': deviceId,
    'user_id': userId,
    'ntp_server_active': config.automatic,
    'ntp_server': config.ntpServer,
    'ntp_server_2': config.secondaryNtpServer.isEmpty
        ? null
        : config.secondaryNtpServer,
    'timezone': config.timezoneTz,
    'timezonename': config.timezone,
    'time_change_active': true,
  };
}

MatterConfig mapMatterConfig(Map<String, dynamic>? row) {
  if (row == null) return const MatterConfig();

  return MatterConfig(
    enabled: intToBool(row['pairing_active'] as int?) ||
        (row['is_commissioned'] as bool? ?? false),
    paired: row['is_commissioned'] as bool? ?? false,
    setupCode: row['setup_passcode'] as String? ?? '',
    qrPayload: row['qr_code'] as String? ?? '',
    fabricCount: 1,
    threadEnabled: true,
  );
}

Map<String, dynamic> matterPayload(
  String deviceId,
  String userId,
  MatterConfig config,
) {
  return {
    'device_id': deviceId,
    'user_id': userId,
    'pairing_active': boolToInt(config.enabled && !config.paired),
  };
}

DeviceLocation mapDeviceLocation(Map<String, dynamic>? row) {
  if (row == null) return const DeviceLocation();

  return DeviceLocation(
    deviceName: row['name'] as String? ?? '',
    houseName: row['home'] as String? ?? '',
    floorName: row['floor'] as String? ?? '',
    roomName: row['room'] as String? ?? '',
  );
}

Map<String, dynamic> deviceLocationPayload(
  String deviceId,
  String userId,
  DeviceLocation location,
) {
  return {
    'device_id': deviceId,
    'user_id': userId,
    'name': location.deviceName,
    'home': location.houseName,
    'floor': location.floorName,
    'room': location.roomName,
  };
}

bool intToBool(int? value) => value == 1;

int boolToInt(bool value) => value ? 1 : 0;

LedStatus ledStateFromInt(int? value) {
  return switch (value) {
    0 => LedStatus.alwaysOff,
    1 => LedStatus.alwaysOn,
    2 => LedStatus.scheduled,
    3 => LedStatus.sunBased,
    _ => LedStatus.alwaysOn,
  };
}

int ledStateToInt(LedStatus status) {
  return switch (status) {
    LedStatus.alwaysOff => 0,
    LedStatus.alwaysOn => 1,
    LedStatus.scheduled => 2,
    LedStatus.sunBased => 3,
  };
}

/// 1 = jeden Tag, 2 = Montag bis Freitag, 3 = nur Wochenende, 4 = bestimmter Tag.
CommandType commandTypeFromMode(int? mode) {
  return switch (mode) {
    2 => CommandType.weekdays,
    3 => CommandType.weekend,
    4 => CommandType.specificDay,
    _ => CommandType.everyday,
  };
}

int commandTypeToMode(CommandType type) {
  return switch (type) {
    CommandType.everyday => 1,
    CommandType.weekdays => 2,
    CommandType.weekend => 3,
    CommandType.specificDay => 4,
  };
}

GeneralConfig mapGeneralConfig(Map<String, dynamic>? row) {
  if (row == null) return const GeneralConfig();

  final r = row['rgb_color_r'] as int? ?? 0;
  final g = row['rgb_color_g'] as int? ?? 112;
  final b = row['rgb_color_b'] as int? ?? 234;
  final color = 0xFF000000 | (r << 16) | (g << 8) | b;

  final start = row['cmd_start'] as String?;
  final end = row['cmd_end'] as String?;

  return GeneralConfig(
    ledColorValue: color,
    brightness: row['brightness'] as int? ?? 80,
    ledStatus: ledStateFromInt(row['led_state'] as int?),
    commandType: commandTypeFromMode(row['mode'] as int?),
    startTime: start != null && start.length >= 5 ? start.substring(0, 5) : '18:00',
    endTime: end != null && end.length >= 5 ? end.substring(0, 5) : '23:00',
    specificDate: row['cmd_date'] as String?,
  );
}

Map<String, dynamic> generalConfigPayload(
  String deviceId,
  String userId,
  GeneralConfig config, {
  bool includeMode = true,
}) {
  final color = config.ledColorValue;
  return {
    'device_id': deviceId,
    'user_id': userId,
    'rgb_color_r': (color >> 16) & 0xFF,
    'rgb_color_g': (color >> 8) & 0xFF,
    'rgb_color_b': color & 0xFF,
    'brightness': config.brightness,
    'led_state': ledStateToInt(config.ledStatus),
    if (includeMode) 'mode': commandTypeToMode(config.commandType),
    'cmd_start': '${config.startTime}:00',
    'cmd_end': '${config.endTime}:00',
    if (config.specificDate != null) 'cmd_date': config.specificDate,
  };
}

UpdateSchedule scheduleFromMode(int? mode) {
  return switch (mode) {
    2 => UpdateSchedule.weekdays,
    3 => UpdateSchedule.weekend,
    4 => UpdateSchedule.specificDay,
    _ => UpdateSchedule.everyDay,
  };
}

int scheduleToMode(UpdateSchedule schedule) {
  return switch (schedule) {
    UpdateSchedule.everyDay => 1,
    UpdateSchedule.weekdays => 2,
    UpdateSchedule.weekend => 3,
    UpdateSchedule.specificDay => 4,
  };
}

Weekday weekdayFromDay(int? day) {
  if (day == null || day < 1 || day > 7) return Weekday.monday;
  return Weekday.values[day - 1];
}

int weekdayToDay(Weekday weekday) => Weekday.values.indexOf(weekday) + 1;

UpdateConfig mapUpdateConfig({
  Map<String, dynamic>? settings,
  Map<String, dynamic>? ota,
}) {
  final current = settings?['current_version'] as String? ?? 'v1.0.0';
  final available = ota?['version'] as String? ?? current;
  final hasUpdate = available != current;

  return UpdateConfig(
    osName: ota?['device_type'] as String? ?? 'Virtumi OS',
    currentVersion: current.startsWith('v') ? current : 'v$current',
    availableVersion: available.startsWith('v') ? available : 'v$available',
    updateAvailable: hasUpdate,
    description: hasUpdate
        ? 'Ein neues System-Update steht zur Verfügung.'
        : 'Dein System ist auf dem neuesten Stand.',
    autoUpdatesEnabled: intToBool(settings?['active'] as int?),
    updateSchedule: scheduleFromMode(settings?['mode'] as int?),
    weekday: weekdayFromDay(settings?['day'] as int?),
    scheduledTime: settings?['time'] as String? ?? '23:50:00',
  );
}

Map<String, dynamic> updateSettingsPayload(
  String deviceId,
  String userId,
  UpdateConfig config,
) {
  return {
    'device_id': deviceId,
    'user_id': userId,
    'active': boolToInt(config.autoUpdatesEnabled),
    'mode': scheduleToMode(config.updateSchedule),
    'day': config.updateSchedule == UpdateSchedule.specificDay
        ? weekdayToDay(config.weekday)
        : null,
    'time': config.scheduledTime,
    'current_version': config.currentVersion.replaceFirst('v', ''),
  };
}
