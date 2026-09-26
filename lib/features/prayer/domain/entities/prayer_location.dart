import 'package:equatable/equatable.dart';

class PrayerLocation extends Equatable {
  final double latitude;
  final double longitude;
  final String title;

  const PrayerLocation({
    required this.latitude,
    required this.longitude,
    required this.title,
  });

  @override
  List<Object?> get props => [latitude, longitude, title];
}
