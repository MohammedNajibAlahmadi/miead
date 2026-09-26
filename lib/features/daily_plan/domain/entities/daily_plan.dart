import 'package:equatable/equatable.dart';
import 'task.dart';
import '../../../../core/datetime/time_engine.dart';

class DailyPlan extends Equatable {
  final LocalDate date;
  final List<Task> tasks;
  final LocalTime wakeTime;
  final LocalTime sleepTime;

  const DailyPlan({
    required this.date,
    this.tasks = const [],
    required this.wakeTime,
    required this.sleepTime,
  });

  @override
  List<Object?> get props => [date, tasks, wakeTime, sleepTime];
}
