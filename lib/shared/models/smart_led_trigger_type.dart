/// Smart LED trigger recurrence types stored as integers 1–4 in smart_led_triggers.
enum SmartLedTriggerType {
  everyDay(1, 'Jeden Tag'),
  weekdays(2, 'Montag bis Freitag'),
  weekend(3, 'Nur Wochenende'),
  specificDay(4, 'Bestimmter Tag');

  const SmartLedTriggerType(this.value, this.label);

  final int value;
  final String label;

  static SmartLedTriggerType? fromValue(int value) {
    for (final type in values) {
      if (type.value == value) return type;
    }
    return null;
  }

  static SmartLedTriggerType get defaultType => SmartLedTriggerType.everyDay;
}
