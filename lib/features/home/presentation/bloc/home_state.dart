import 'package:equatable/equatable.dart';
import '../../data/repositories/task_repository.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  final HomeStatus status;
  final String dateString;
  final String? currentActivity;
  final String? nextPrayerName;
  final String? nextPrayerTime;
  final List<TaskItem> tasks;
  final bool isFriday;
  final String? dynamicInspiration;
  
  const HomeState({
    this.status = HomeStatus.initial,
    this.dateString = '',
    this.currentActivity,
    this.nextPrayerName,
    this.nextPrayerTime,
    this.tasks = const [],
    this.isFriday = false,
    this.dynamicInspiration,
  });

  HomeState copyWith({
    HomeStatus? status,
    String? dateString,
    String? currentActivity,
    String? nextPrayerName,
    String? nextPrayerTime,
    List<TaskItem>? tasks,
    bool? isFriday,
    String? dynamicInspiration,
  }) {
    return HomeState(
      status: status ?? this.status,
      dateString: dateString ?? this.dateString,
      currentActivity: currentActivity ?? this.currentActivity,
      nextPrayerName: nextPrayerName ?? this.nextPrayerName,
      nextPrayerTime: nextPrayerTime ?? this.nextPrayerTime,
      tasks: tasks ?? this.tasks,
      isFriday: isFriday ?? this.isFriday,
      dynamicInspiration: dynamicInspiration ?? this.dynamicInspiration,
    );
  }

  @override
  List<Object?> get props => [status, dateString, currentActivity, nextPrayerName, nextPrayerTime, tasks, isFriday, dynamicInspiration];
}
