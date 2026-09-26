import 'clock.dart';

class FakeClock implements AppClock {
  DateTime _now;

  FakeClock(this._now);

  @override
  DateTime now() => _now;

  void advanceBy(Duration duration) {
    _now = _now.add(duration);
  }

  void setTime(DateTime time) {
    _now = time;
  }
}
