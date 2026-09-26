import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class Instant extends Equatable {
  final DateTime dateTime;
  const Instant(this.dateTime);
  
  factory Instant.now() => Instant(DateTime.now().toUtc());

  @override
  List<Object?> get props => [dateTime.toUtc().millisecondsSinceEpoch];
}

class LocalDate extends Equatable {
  final int year;
  final int month;
  final int day;

  const LocalDate(this.year, this.month, this.day);

  factory LocalDate.fromDateTime(DateTime dt) {
    return LocalDate(dt.year, dt.month, dt.day);
  }

  DateTime toDateTime() => DateTime(year, month, day);

  @override
  List<Object?> get props => [year, month, day];
}

class LocalTime extends Equatable {
  final int hour;
  final int minute;
  final int second;

  const LocalTime(this.hour, this.minute, this.second);

  factory LocalTime.fromDateTime(DateTime dt) {
    return LocalTime(dt.hour, dt.minute, dt.second);
  }

  String format({bool use24Hour = false}) {
    final dt = DateTime(2000, 1, 1, hour, minute, second);
    return use24Hour ? DateFormat('HH:mm').format(dt) : DateFormat('hh:mm a').format(dt);
  }

  @override
  List<Object?> get props => [hour, minute, second];
}
