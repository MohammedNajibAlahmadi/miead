import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/alarm.dart';
import '../../data/repositories/alarm_repository.dart';
import '../../../../core/datetime/time_engine.dart';
import 'alarms_state.dart';

class AlarmsCubit extends Cubit<AlarmsState> {
  final AlarmRepository _repository;

  AlarmsCubit(this._repository) : super(const AlarmsState()) {
    _loadAlarms();
  }

  Future<void> _loadAlarms() async {
    var list = await _repository.getAllAlarms();
    if (list.isEmpty) {
      await _repository.insertAlarm(const AlarmDefinition(
        id: '1', title: 'صلاة قيام الليل', time: LocalTime(4, 15, 0), isActive: true, activeDays: [1, 2, 3, 4, 5, 6, 7],
      ));
      await _repository.insertAlarm(const AlarmDefinition(
        id: '2', title: 'العمل (موعد الدوام)', time: LocalTime(7, 30, 0), isActive: false, activeDays: [1, 2, 3, 4, 5, 6, 7],
      ));
      list = await _repository.getAllAlarms();
    }
    emit(state.copyWith(alarms: list));
  }

  Future<void> toggleAlarm(String id) async {
    final alarmIndex = state.alarms.indexWhere((a) => a.id == id);
    if (alarmIndex == -1) return;
    
    final alarm = state.alarms[alarmIndex];
    final updatedAlarm = AlarmDefinition(
      id: alarm.id,
      title: alarm.title,
      time: alarm.time,
      isActive: !alarm.isActive,
      activeDays: alarm.activeDays,
      soundPath: alarm.soundPath,
      vibration: alarm.vibration,
    );
    
    // Optimistic UI update
    final updatedList = List<AlarmDefinition>.from(state.alarms);
    updatedList[alarmIndex] = updatedAlarm;
    emit(state.copyWith(alarms: updatedList));
    
    // Save to DB
    await _repository.updateAlarm(updatedAlarm);
  }
}
