import '../../../models/cp_parameter.dart';
import '../../../models/smart_led_strip.dart';
import '../../../models/smart_led_trigger.dart';
import '../../../models/device_data_entry.dart';

CpParameter mapCpParameter(Map<String, dynamic> row) {
  return CpParameter(
    id: row['id'] as String?,
    parameterIndex: row['parameter_index'] as int,
    active: row['active'] as int? ?? 0,
    enabled: row['enabled'] as int? ?? 0,
    init: row['init'] as int? ?? 0,
    mode: row['mode'] as int? ?? 1,
    macAddress: row['mac_address'] as String? ?? '',
    ipAddress: row['ip_address'] as String? ?? '',
    port: row['port'] as int?,
    ipv6: row['ipv6'] as String? ?? '',
    channel: row['channel'] as int? ?? 1,
    name: row['name'] as String? ?? '',
    code: row['code'] as String? ?? '',
    resourceName: row['resource_name'] as String? ?? '',
    deviceType: row['device_type'] as int? ?? 0,
    command0Active: row['command_0_active'] as int? ?? 0,
    command0Exists: row['command_0_exists'] as int? ?? 0,
    command0Function: row['command_0_function'] as int? ?? 0,
    command0ProtokolNr: row['command_0_protokol_nr'] as int? ?? 0,
    command1Active: row['command_1_active'] as int? ?? 0,
    command1Exists: row['command_1_exists'] as int? ?? 0,
    command1Function: row['command_1_function'] as int? ?? 0,
    command1ProtokolNr: row['command_1_protokol_nr'] as int? ?? 0,
    command2Active: row['command_2_active'] as int? ?? 0,
    command2Exists: row['command_2_exists'] as int? ?? 0,
    command2Function: row['command_2_function'] as int? ?? 0,
    command2ProtokolNr: row['command_2_protokol_nr'] as int? ?? 0,
  );
}

Map<String, dynamic> cpParameterPayload(
  String deviceId,
  String userId,
  CpParameter p,
) {
  return {
    if (p.id != null) 'id': p.id,
    'device_id': deviceId,
    'user_id': userId,
    'parameter_index': p.parameterIndex,
    'active': p.active,
    'enabled': p.enabled,
    'init': p.init,
    'mode': p.mode,
    'mac_address': p.macAddress,
    'ip_address': p.ipAddress,
    'port': p.port,
    'ipv6': p.ipv6,
    'channel': p.channel,
    'name': p.name,
    'code': p.code,
    'resource_name': p.resourceName,
    'device_type': p.deviceType,
    'command_0_active': p.command0Active,
    'command_0_exists': p.command0Exists,
    'command_0_function': p.command0Function,
    'command_0_protokol_nr': p.command0ProtokolNr,
    'command_1_active': p.command1Active,
    'command_1_exists': p.command1Exists,
    'command_1_function': p.command1Function,
    'command_1_protokol_nr': p.command1ProtokolNr,
    'command_2_active': p.command2Active,
    'command_2_exists': p.command2Exists,
    'command_2_function': p.command2Function,
    'command_2_protokol_nr': p.command2ProtokolNr,
  };
}

SmartLedStrip mapSmartLedStrip(Map<String, dynamic> row) {
  return SmartLedStrip(
    ledIndex: row['led_index'] as int,
    ledCount: row['led_count'] as int? ?? 1,
    rgbColorR: row['rgb_color_r'] as int? ?? 0,
    rgbColorG: row['rgb_color_g'] as int? ?? 0,
    rgbColorB: row['rgb_color_b'] as int? ?? 0,
    rgbColorR2: row['rgb_color_r2'] as int? ?? 0,
    rgbColorG2: row['rgb_color_g2'] as int? ?? 0,
    rgbColorB2: row['rgb_color_b2'] as int? ?? 0,
    speed: row['speed'] as int? ?? 0,
    effectNumber: row['effect_number'] as int? ?? 0,
    ledOn: row['led_on'] as int? ?? 0,
    available: row['available'] as int? ?? 0,
    autoMode: row['auto_mode'] as int? ?? 0,
    autoModeTime: row['auto_mode_time'] as int? ?? 0,
    ledFunctionNr: row['led_function_nr'] as int? ?? 0,
    brightness: row['brightness'] as int? ?? 10,
    offAutomatic: row['off_automatic'] as int? ?? 0,
    maxBrightness: row['max_brightness'] as int? ?? 100,
    offTime: row['off_time'] as String? ?? '',
  );
}

Map<String, dynamic> smartLedStripPayload(
  String deviceId,
  SmartLedStrip strip,
) {
  return {
    'device_id': deviceId,
    'led_index': strip.ledIndex,
    'led_count': strip.ledCount,
    'rgb_color_r': strip.rgbColorR,
    'rgb_color_g': strip.rgbColorG,
    'rgb_color_b': strip.rgbColorB,
    'rgb_color_r2': strip.rgbColorR2,
    'rgb_color_g2': strip.rgbColorG2,
    'rgb_color_b2': strip.rgbColorB2,
    'speed': strip.speed,
    'effect_number': strip.effectNumber,
    'led_on': strip.ledOn,
    'available': strip.available,
    'auto_mode': strip.autoMode,
    'auto_mode_time': strip.autoModeTime,
    'led_function_nr': strip.ledFunctionNr,
    'brightness': strip.brightness,
    'off_automatic': strip.offAutomatic,
    'max_brightness': strip.maxBrightness,
    'off_time': strip.offTime.isEmpty ? null : strip.offTime,
  };
}

SmartLedTrigger mapSmartLedTrigger(Map<String, dynamic> row) {
  return SmartLedTrigger(
    id: row['id'] as String?,
    parameterIndex: row['parameter_index'] as int,
    active: row['active'] as int? ?? 0,
    done: row['done'] as int? ?? 0,
    changeSwitchState: row['change_switch_state'] as int? ?? 0,
    changeBrightness: row['change_brightness'] as int? ?? 0,
    changeOffAutomatic: row['change_off_automatic'] as int? ?? 0,
    lampOn: row['lamp_on'] as int? ?? 0,
    offAutomatic: row['off_automatic'] as int? ?? 0,
    changeLedEffect: row['change_led_effect'] as int? ?? 0,
    brightness: row['brightness'] as int? ?? 0,
    effectNumber: row['effect_number'] as int? ?? 0,
    triggerType: row['trigger_type'] as int? ?? 1,
    name: row['name'] as String? ?? '',
    commandTimeHour: row['command_time_hour'] as int? ?? 0,
    commandTimeMinute: row['command_time_minute'] as int? ?? 0,
    commandTimeSecond: row['command_time_second'] as int? ?? 0,
    offAutomaticTimeHour: row['off_automatic_time_hour'] as int? ?? 0,
    offAutomaticTimeMinute: row['off_automatic_time_minute'] as int? ?? 0,
    offAutomaticTimeSecond: row['off_automatic_time_second'] as int? ?? 0,
    commandDateDay: row['command_date_day'] as int? ?? 1,
    commandDateMonth: row['command_date_month'] as int? ?? 1,
    commandDateYear: row['command_date_year'] as int? ?? 2026,
  );
}

Map<String, dynamic> smartLedTriggerPayload(
  String deviceId,
  String userId,
  SmartLedTrigger trigger,
) {
  return {
    if (trigger.id != null) 'id': trigger.id,
    'device_id': deviceId,
    'user_id': userId,
    'parameter_index': trigger.parameterIndex,
    'active': trigger.active,
    'done': trigger.done,
    'change_switch_state': trigger.changeSwitchState,
    'change_brightness': trigger.changeBrightness,
    'change_off_automatic': trigger.changeOffAutomatic,
    'lamp_on': trigger.lampOn,
    'off_automatic': trigger.offAutomatic,
    'change_led_effect': trigger.changeLedEffect,
    'brightness': trigger.brightness,
    'effect_number': trigger.effectNumber,
    'trigger_type': trigger.triggerType,
    'name': trigger.name,
    'command_time_hour': trigger.commandTimeHour,
    'command_time_minute': trigger.commandTimeMinute,
    'command_time_second': trigger.commandTimeSecond,
    'off_automatic_time_hour': trigger.offAutomaticTimeHour,
    'off_automatic_time_minute': trigger.offAutomaticTimeMinute,
    'off_automatic_time_second': trigger.offAutomaticTimeSecond,
    'command_date_day': trigger.commandDateDay,
    'command_date_month': trigger.commandDateMonth,
    'command_date_year': trigger.commandDateYear,
  };
}

DeviceDataEntry mapDeviceDataEntry(Map<String, dynamic> row) {
  return DeviceDataEntry(
    id: row['id'] as String,
    receivedAt: DateTime.parse(row['received_at'] as String),
    data: Map<String, dynamic>.from(row['data'] as Map? ?? {}),
  );
}

DeviceUpdateStatus mapDeviceUpdateStatus(Map<String, dynamic>? row) {
  if (row == null) return const DeviceUpdateStatus();
  return DeviceUpdateStatus(
    status: row['status'] as String? ?? 'idle',
    errorMessage: row['error_message'] as String?,
    lastUpdateRequest: row['last_update_request'] != null
        ? DateTime.parse(row['last_update_request'] as String)
        : null,
  );
}

List<CpParameter> defaultCpParameters() {
  return List.generate(10, (i) => CpParameter(parameterIndex: i));
}

List<SmartLedTrigger> defaultSmartLedTriggers() {
  return List.generate(10, (i) => SmartLedTrigger(parameterIndex: i));
}

List<SmartLedStrip> defaultSmartLedStrips() {
  return [1, 2, 3].map((i) => SmartLedStrip(ledIndex: i)).toList();
}
