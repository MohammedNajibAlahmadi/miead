import 'package:equatable/equatable.dart';

class DailyPrayerRecord extends Equatable {
  final String date;
  final bool fajr;
  final bool dhuhr;
  final bool asr;
  final bool maghrib;
  final bool isha;

  const DailyPrayerRecord({
    required this.date,
    this.fajr = false,
    this.dhuhr = false,
    this.asr = false,
    this.maghrib = false,
    this.isha = false,
  });

  DailyPrayerRecord copyWith({
    String? date,
    bool? fajr,
    bool? dhuhr,
    bool? asr,
    bool? maghrib,
    bool? isha,
  }) {
    return DailyPrayerRecord(
      date: date ?? this.date,
      fajr: fajr ?? this.fajr,
      dhuhr: dhuhr ?? this.dhuhr,
      asr: asr ?? this.asr,
      maghrib: maghrib ?? this.maghrib,
      isha: isha ?? this.isha,
    );
  }

  @override
  List<Object?> get props => [date, fajr, dhuhr, asr, maghrib, isha];
}
