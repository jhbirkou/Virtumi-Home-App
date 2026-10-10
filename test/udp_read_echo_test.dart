import 'package:flutter_test/flutter_test.dart';
import 'package:virtumi_home/shared/data/udp/udp_read_echo.dart';

void main() {
  group('isBareReadRequestEcho', () {
    test('detects echo without payload', () {
      expect(
        isBareReadRequestEcho({
          'protocol_nr': 0,
          'reply_protocol': 6,
          'code': 'abc',
        }, 6),
        isTrue,
      );
    });

    test('rejects response with payload data', () {
      expect(
        isBareReadRequestEcho({
          'protocol_nr': 0,
          'reply_protocol': 6,
          'code': 'abc',
          'brightness': 80,
        }, 6),
        isFalse,
      );
    });

    test('rejects wrong reply protocol', () {
      expect(
        isBareReadRequestEcho({
          'protocol_nr': 0,
          'reply_protocol': 5,
          'code': 'abc',
        }, 6),
        isFalse,
      );
    });
  });
}
