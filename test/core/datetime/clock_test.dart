import 'package:flutter_test/flutter_test.dart';
import 'package:miead/core/datetime/fake_clock.dart';

void main() {
  test('FakeClock should return initialized time and advance correctly', () {
    final startTime = DateTime(2026, 1, 1, 12, 0);
    final clock = FakeClock(startTime);

    expect(clock.now(), equals(startTime));

    clock.advanceBy(const Duration(hours: 1));
    expect(clock.now(), equals(DateTime(2026, 1, 1, 13, 0)));

    final newTime = DateTime(2027, 2, 2);
    clock.setTime(newTime);
    expect(clock.now(), equals(newTime));
  });
}
