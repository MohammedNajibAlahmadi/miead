import 'package:equatable/equatable.dart';

class QuranSession extends Equatable {
  final String id;
  final DateTime startTime;
  final Duration duration;
  final int pagesRead;
  final String notes;

  const QuranSession({
    required this.id,
    required this.startTime,
    required this.duration,
    this.pagesRead = 0,
    this.notes = '',
  });

  @override
  List<Object?> get props => [id, startTime, duration, pagesRead, notes];
}
