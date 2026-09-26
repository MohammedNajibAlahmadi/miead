import 'package:equatable/equatable.dart';

class FocusStats extends Equatable {
  final DateTime date;
  final int totalFocusMinutes;
  final int tasksCompleted;
  final int dhikrCount;

  const FocusStats({
    required this.date,
    this.totalFocusMinutes = 0,
    this.tasksCompleted = 0,
    this.dhikrCount = 0,
  });

  @override
  List<Object?> get props => [date, totalFocusMinutes, tasksCompleted, dhikrCount];
}
