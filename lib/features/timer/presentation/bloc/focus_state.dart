import 'package:equatable/equatable.dart';
import '../../domain/entities/timer_session.dart';

class FocusState extends Equatable {
  final TimerSession session;

  const FocusState({required this.session});

  FocusState copyWith({TimerSession? session}) {
    return FocusState(session: session ?? this.session);
  }

  @override
  List<Object?> get props => [session];
}
