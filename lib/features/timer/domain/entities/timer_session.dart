import 'package:equatable/equatable.dart';

enum TimerState { idle, prepared, running, paused, completed, archived }
enum SessionType { study, quran, reading, work, custom }

class TimerSession extends Equatable {
  final String id;
  final SessionType type;
  final String? customLabel;
  final Duration duration;
  final Duration elapsed;
  final TimerState state;
  final DateTime? startTime;

  const TimerSession({
    required this.id,
    required this.type,
    this.customLabel,
    required this.duration,
    this.elapsed = Duration.zero,
    this.state = TimerState.idle,
    this.startTime,
  });

  TimerSession copyWith({
    SessionType? type,
    String? customLabel,
    Duration? duration,
    Duration? elapsed,
    TimerState? state,
    DateTime? startTime,
  }) {
    return TimerSession(
      id: id,
      type: type ?? this.type,
      customLabel: customLabel ?? this.customLabel,
      duration: duration ?? this.duration,
      elapsed: elapsed ?? this.elapsed,
      state: state ?? this.state,
      startTime: startTime ?? this.startTime,
    );
  }

  @override
  List<Object?> get props => [id, type, customLabel, duration, elapsed, state, startTime];
}
