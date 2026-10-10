const _readRequestNoiseKeys = {
  'protocol_nr',
  'reply_protocol',
  'code',
  'command',
};

int? _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

/// Returns true when [raw] is an echo of a read request without payload data.
bool isBareReadRequestEcho(
  Map<String, dynamic> raw,
  int expectedReplyProtocol,
) {
  if (_asInt(raw['protocol_nr']) != 0) return false;
  if (_asInt(raw['reply_protocol']) != expectedReplyProtocol) return false;

  for (final key in raw.keys) {
    if (_readRequestNoiseKeys.contains(key)) continue;
    final value = raw[key];
    if (value == null) continue;
    if (value is String && value.trim().isEmpty) continue;
    return false;
  }
  return true;
}
