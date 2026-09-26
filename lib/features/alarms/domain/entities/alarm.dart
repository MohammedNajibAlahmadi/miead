import 'package:equatable/equatable.dart';
import '../../../../core/datetime/time_engine.dart';

class AlarmDefinition extends Equatable {
  final String id;
  final String title;
  final LocalTime time;
  final bool isActive;
  final List<int> activeDays; // 1 = Mon ... 7 = Sun
  final String soundPath;
  final bool vibration;

  const AlarmDefinition({
    required this.id,
    required this.title,
    required this.time,
    this.isActive = true,
    this.activeDays = const [],
    this.soundPath = 'default',
    this.vibration = true,
  });

  @override
  List<Object?> get props => [id, title, time, isActive, activeDays, soundPath, vibration];
}

class AlarmOccurrence extends Equatable {
  final String id;
  final String alarmDefinitionId;
  final Instant scheduledAt;
  final bool isFired;

  const AlarmOccurrence({
    required this.id,
    required this.alarmDefinitionId,
    required this.scheduledAt,
    this.isFired = false,
  });

  @override
  List<Object?> get props => [id, alarmDefinitionId, scheduledAt, isFired];
}
