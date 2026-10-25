/// Connection type stored as [CpParameter.mode].
enum CpParameterMode {
  direct(1, 'Direkte Verbindung'),
  localNetwork(2, 'Verbindung über Lokales Netzwerk');

  const CpParameterMode(this.value, this.label);

  final int value;
  final String label;

  static CpParameterMode? fromValue(int value) {
    for (final mode in values) {
      if (mode.value == value) return mode;
    }
    return null;
  }

  static CpParameterMode get defaultMode => CpParameterMode.direct;
}
