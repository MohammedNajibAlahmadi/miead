import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/prayer_tracker_repository.dart';
import '../../domain/entities/daily_prayer_record.dart';

class PrayerTrackerCubit extends Cubit<DailyPrayerRecord> {
  final PrayerTrackerRepository _repository;
  final String todayDate;

  PrayerTrackerCubit(this._repository) 
      : todayDate = DateTime.now().toIso8601String().substring(0, 10),
        super(DailyPrayerRecord(date: DateTime.now().toIso8601String().substring(0, 10))) {
    _loadTodayRecord();
  }

  void _loadTodayRecord() async {
    final record = await _repository.getRecord(todayDate);
    emit(record);
  }

  void togglePrayer(String prayerCode, bool value) async {
    DailyPrayerRecord updated = state;
    switch (prayerCode) {
      case 'fajr': updated = state.copyWith(fajr: value); break;
      case 'dhuhr': updated = state.copyWith(dhuhr: value); break;
      case 'asr': updated = state.copyWith(asr: value); break;
      case 'maghrib': updated = state.copyWith(maghrib: value); break;
      case 'isha': updated = state.copyWith(isha: value); break;
    }
    emit(updated);
    await _repository.updateRecord(updated);
  }
}
