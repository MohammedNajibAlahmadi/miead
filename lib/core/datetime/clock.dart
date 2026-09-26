abstract class AppClock {
  DateTime now();
}

class SystemClock implements AppClock {
  @override
  DateTime now() => DateTime.now();
}
