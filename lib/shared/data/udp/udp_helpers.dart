const defaultUdpPort = 6000;

final _ipv4Re = RegExp(
  r'^(?:(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)\.){3}(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)$',
);

String requireIpv4(String? ip) {
  final raw = ip?.trim();
  if (raw == null || raw.isEmpty) {
    throw ArgumentError(
      'Keine IP-Adresse für Direktverbindung. Bitte Geräte-IP prüfen.',
    );
  }
  if (!_ipv4Re.hasMatch(raw)) {
    throw ArgumentError('Ungültige IPv4-Adresse: $raw');
  }
  return raw;
}

String requireDeviceCode(String? code) {
  final raw = code?.trim();
  if (raw == null || raw.isEmpty) {
    throw ArgumentError('Kein Gerätecode vorhanden.');
  }
  return raw;
}

int parsePort(String? port, {int fallback = defaultUdpPort}) {
  return int.tryParse(port?.trim() ?? '') ?? fallback;
}
