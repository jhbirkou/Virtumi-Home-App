/// High-level Virtumi device category for protocol payload selection.
enum DeviceKind {
  controlPanel,
  smartLed,
}

DeviceKind resolveDeviceKind(String? deviceTypeName) {
  final n = (deviceTypeName ?? '').trim().toLowerCase();
  if (n.contains('smart') && n.contains('led')) return DeviceKind.smartLed;
  return DeviceKind.controlPanel;
}

bool isSmartLedUdpPayload(Map<String, dynamic> json) {
  return json.containsKey('effect_number') ||
      json.containsKey('led_count') ||
      json.containsKey('rgb_color_r2') ||
      json.containsKey('led_mode') ||
      json.containsKey('auto_mode') ||
      json.containsKey('off_automatic') ||
      json.containsKey('max_brightness') ||
      json.containsKey('off_time');
}

bool isCpParameterUdpPayload(Map<String, dynamic> json) {
  return json.containsKey('commands') || json.containsKey('enabled');
}

bool isSmartLedTriggerUdpPayload(Map<String, dynamic> json) {
  return json.containsKey('change_switch_state') ||
      json.containsKey('trigger_type') ||
      json.containsKey('parameter_index');
}

bool isStripUdpPayload(Map<String, dynamic> json) {
  return json.containsKey('led_index') &&
      (json.containsKey('led_on') ||
          json.containsKey('led_count') ||
          json.containsKey('available') ||
          json.containsKey('effect_number'));
}
