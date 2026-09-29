import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/datetime/clock.dart';
import '../../../prayer/domain/services/prayer_engine.dart';
import '../../../prayer/domain/entities/prayer_location.dart';
import 'package:adhan/adhan.dart';
import '../../data/repositories/task_repository.dart';
import '../../../../core/gamification/motivation_engine.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final AppClock _clock;
  final PrayerEngine _prayerEngine;
  final TaskRepository _taskRepository;
  final MotivationEngine _motivationEngine;
  Timer? _ticker;

  HomeCubit(this._clock, this._prayerEngine, this._taskRepository, this._motivationEngine) : super(const HomeState()) {
    loadHomeData();
    _startTicker();
  }

  void _startTicker() {
    _ticker = Timer.periodic(const Duration(minutes: 1), (_) {
      _refreshTimeSync();
    });
  }

  void _refreshTimeSync() {
    if (state.status != HomeStatus.success) return;
    
    final now = _clock.now();
    final dateString = '${now.year}/${now.month}/${now.day}';
    final location = const PrayerLocation(latitude: 21.4225, longitude: 39.8262, title: 'مكة المكرمة');
    
    final prayerTimes = _prayerEngine.calculatePrayerTimes(location: location, date: now);
    final nextPrayer = _prayerEngine.getNextPrayer(prayerTimes);
    
    String? nextPrayerName;
    String? nextPrayerTimeStr;
    
    if (nextPrayer != null && nextPrayer != Prayer.none) {
      final time = _prayerEngine.timeForPrayer(prayerTimes, nextPrayer);
      if (time != null) {
        nextPrayerName = _getArabicPrayerName(nextPrayer);
        final difference = time.difference(now);
        // Live countdown mechanism (Time remaining)
        if (difference.inHours > 0) {
          nextPrayerTimeStr = "متبقي ${difference.inHours}س و ${difference.inMinutes.remainder(60)}د";
        } else {
          nextPrayerTimeStr = "متبقي ${difference.inMinutes} دقيقة";
        }
      }
    } else {
      nextPrayerName = 'الفجر';
      nextPrayerTimeStr = 'غداً';
    }

    final isFridayTemp = now.weekday == DateTime.friday;

    emit(state.copyWith(
      dateString: dateString,
      nextPrayerName: nextPrayerName,
      nextPrayerTime: nextPrayerTimeStr,
      isFriday: isFridayTemp,
    ));
  }

  void loadHomeData() async {
    emit(state.copyWith(status: HomeStatus.loading));
    
    try {
      final now = _clock.now();
      final dateIso = now.toIso8601String().substring(0, 10);
      final tasks = await _taskRepository.getTasks(dateIso);
      final inspiration = _motivationEngine.getDailyInspiration();
      
      // Seed first success state
      emit(state.copyWith(
        status: HomeStatus.success,
        tasks: tasks,
        currentActivity: null,
        dynamicInspiration: inspiration,
      ));
      
      // Calculate times natively
      _refreshTimeSync();
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
    
    // Evaluate if task deserves a specialized gamification notification
    final encouragement = _motivationEngine.getTaskEncouragement(title.trim());
    if (encouragement != null) {
      _motivationEngine.pushEncouragement(
        'مهمة عظيمة!',
        encouragement,
      );
    }
    
    final tasks = await _taskRepository.getTasks(dateIso);
    emit(state.copyWith(tasks: tasks));
  }

  @override
  Future<void> close() {
    _ticker?.cancel();
    return super.close();
  }
}

