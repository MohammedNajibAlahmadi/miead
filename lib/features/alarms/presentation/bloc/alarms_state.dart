import 'package:equatable/equatable.dart';
import '../../domain/entities/alarm.dart';

class AlarmsState extends Equatable {
  final List<AlarmDefinition> alarms;

  const AlarmsState({this.alarms = const []});

  AlarmsState copyWith({List<AlarmDefinition>? alarms}) {
    return AlarmsState(alarms: alarms ?? this.alarms);
  }

  @override
  List<Object?> get props => [alarms];
}
