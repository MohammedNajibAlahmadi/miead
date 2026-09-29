import 'package:equatable/equatable.dart';
import '../../domain/entities/timer_session.dart';

class FocusState extends Equatable {
  final TimerSession session;
  final List<String> customTags;

  const FocusState({
    required this.session,
    this.customTags = const [],
  });

  FocusState copyWith({TimerSession? session, List<String>? customTags}) {
    return FocusState(
      session: session ?? this.session,
      customTags: customTags ?? this.customTags,
    );
  }

  @override
  List<Object?> get props => [session, customTags];
}
