/// Smart LED button functions stored as integers 1–14 in cp_parameters.
enum CpCommandFunction {
  on(1, 'on'),
  off(2, 'off'),
  onOff(3, 'on_off'),
  brightnessUp(4, 'brightness_up'),
  brightnessDown(5, 'brightness_down'),
  brightnessUpDown(6, 'brightness_up_down'),
  speedUp(7, 'speed_up'),
  speedDown(8, 'speed_down'),
  speedUpDown(9, 'speed_up_down'),
  autoModeOn(10, 'auto_mode_on'),
  autoModeOff(11, 'auto_mode_off'),
  autoModeOnOff(12, 'auto_mode_on_off'),
  modeNext(13, 'mode_next'),
  modeBack(14, 'mode_back');

  const CpCommandFunction(this.value, this.label);

  final int value;
  final String label;

  static CpCommandFunction? fromValue(int value) {
    for (final fn in values) {
      if (fn.value == value) return fn;
    }
    return null;
  }

  static CpCommandFunction get defaultFunction => CpCommandFunction.on;
}
