import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/datetime/clock.dart';
import '../../../prayer/domain/services/prayer_engine.dart';
import '../../../prayer/domain/entities/prayer_location.dart';
import 'package:adhan/adhan.dart';
import '../../data/repositories/task_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final AppClock _clock;
  final PrayerEngine _prayerEngine;
  final TaskRepository _taskRepository;

  HomeCubit(this._clock, this._prayerEngine, this._taskRepository) : super(const HomeState()) {
    loadHomeData();
  }

  void loadHomeData() async {
    emit(state.copyWith(status: HomeStatus.loading));
    
    try {
      final now = _clock.now();
      
      final dateString = '${now.year}/${now.month}/${now.day}';
      
      // Default location for demo (Mecca)
      final location = const PrayerLocation(latitude: 21.4225, longitude: 39.8262, title: 'مكة المكرمة');
      final prayerTimes = _prayerEngine.calculatePrayerTimes(
        location: location,
        date: now,
      );
      
      final nextPrayer = _prayerEngine.getNextPrayer(prayerTimes);
      String? nextPrayerName;
      String? nextPrayerTimeStr;
      
      if (nextPrayer != null && nextPrayer != Prayer.none) {
        final time = _prayerEngine.timeForPrayer(prayerTimes, nextPrayer);
        if (time != null) {
          nextPrayerName = _getArabicPrayerName(nextPrayer);
          nextPrayerTimeStr = "${time.hour > 12 ? time.hour - 12 : time.hour == 0 ? 12 : time.hour}:${time.minute.toString().padLeft(2, '0')}";
        }
      } else {
        nextPrayerName = 'الفجر';
        nextPrayerTimeStr = 'غداً';
      }

      final dateIso = now.toIso8601String().substring(0, 10);
      final tasks = await _taskRepository.getTasks(dateIso);
      final isFridayTemp = now.weekday == DateTime.friday;

      emit(state.copyWith(
        status: HomeStatus.success,
        dateString: dateString,
        currentActivity: null,
        nextPrayerName: nextPrayerName,
        nextPrayerTime: nextPrayerTimeStr,
        tasks: tasks,
        isFriday: isFridayTemp,
      ));
    } catch (e) {
      emit(state.copyWith(status: HomeStatus.failure));
    }
  }

  String _getArabicPrayerName(Prayer prayer) {
    switch (prayer) {
      case Prayer.fajr: return 'الفجر';
      case Prayer.sunrise: return 'الشروق';
      case Prayer.dhuhr: return 'الظهر';
      case Prayer.asr: return 'العصر';
      case Prayer.maghrib: return 'المغرب';
      case Prayer.isha: return 'العشاء';
      case Prayer.none: return '';
    }
  }

  void toggleTask(TaskItem task) async {
    final updatedList = List<TaskItem>.from(state.tasks);
    final index = updatedList.indexWhere((t) => t.id == task.id);
    if(index != -1) {
      updatedList[index] = task.copyWith(isCompleted: !task.isCompleted);
      emit(state.copyWith(tasks: updatedList));
      await _taskRepository.toggleTask(task.id, !task.isCompleted);
    }
  }

  void addTask(String title) async {
    if (title.trim().isEmpty) return;
    
    final now = _clock.now();
    final dateIso = now.toIso8601String().substring(0, 10);
    await _taskRepository.insertTask(title.trim(), dateIso);
    
    final tasks = await _taskRepository.getTasks(dateIso);
    emit(state.copyWith(tasks: tasks));
  }
}
