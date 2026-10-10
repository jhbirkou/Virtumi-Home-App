import 'package:flutter_test/flutter_test.dart';
import 'package:virtumi_home/shared/models/models.dart';

void main() {
  group('User', () {
    test('initials are derived from the name', () {
      const user = User(id: 'u1', name: 'Jalal Hbirkou', email: 'a@b.de');
      expect(user.initials, 'JH');
    });

    test('single-word name yields one initial', () {
      const user = User(id: 'u1', name: 'Jalal', email: 'a@b.de');
      expect(user.initials, 'J');
    });
  });

  group('Device', () {
    test('statusLabel reflects power state', () {
      const device = Device(
        id: 'd1',
        roomId: 'r1',
        name: 'Panel',
        type: DeviceType.controlPanel,
        isOn: true,
      );
      expect(device.statusLabel, 'An');
      expect(device.copyWith(isOn: false).statusLabel, 'Aus');
    });
  });
}
