import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/dependency_injection/di.dart';
import '../../../../core/notifications/notification_engine.dart';
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

  Future<void> addAlarm(AlarmDefinition alarm) async {
    await _repository.insertAlarm(alarm);
    if (alarm.isActive) {
      await getIt<NotificationEngine>().scheduleAlarmNotification(alarm);
    }
    await _loadAlarms();
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
    
    // OS interaction
    if (updatedAlarm.isActive) {
      await getIt<NotificationEngine>().scheduleAlarmNotification(updatedAlarm);
    } else {
      await getIt<NotificationEngine>().cancelAlarm(updatedAlarm.id);
    }
    
    // Save to DB
    await _repository.updateAlarm(updatedAlarm);
  }

  Future<void> updateAlarmTime(String id, LocalTime newTime) async {
    final alarmIndex = state.alarms.indexWhere((a) => a.id == id);
    if (alarmIndex == -1) return;
    
    final alarm = state.alarms[alarmIndex];
    final updatedAlarm = AlarmDefinition(
      id: alarm.id,
      title: alarm.title,
      time: newTime,
      isActive: alarm.isActive,
      activeDays: alarm.activeDays,
      soundPath: alarm.soundPath,
      vibration: alarm.vibration,
    );
    
    final updatedList = List<AlarmDefinition>.from(state.alarms);
    updatedList[alarmIndex] = updatedAlarm;
    emit(state.copyWith(alarms: updatedList));
    
    if (updatedAlarm.isActive) {
      await getIt<NotificationEngine>().scheduleAlarmNotification(updatedAlarm);
    }
    await _repository.updateAlarm(updatedAlarm);
  }

  Future<void> updateFullAlarm(AlarmDefinition updatedAlarm) async {
    final alarmIndex = state.alarms.indexWhere((a) => a.id == updatedAlarm.id);
    if (alarmIndex == -1) return;
    
    final updatedList = List<AlarmDefinition>.from(state.alarms);
    updatedList[alarmIndex] = updatedAlarm;
    emit(state.copyWith(alarms: updatedList));
    
    if (updatedAlarm.isActive) {
      await getIt<NotificationEngine>().scheduleAlarmNotification(updatedAlarm);
    } else {
      await getIt<NotificationEngine>().cancelAlarm(updatedAlarm.id);
    }
    await _repository.updateAlarm(updatedAlarm);
  }
}
