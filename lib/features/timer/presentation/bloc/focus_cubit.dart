import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/timer_session.dart';
import '../../domain/services/timer_engine.dart';
import 'focus_state.dart';

class FocusCubit extends Cubit<FocusState> {
  final TimerEngine _engine;
  Timer? _ticker;

  FocusCubit(this._engine)
      : super(const FocusState(
          session: TimerSession(
            id: 'idle',
            type: SessionType.custom,
            duration: Duration(minutes: 25),
          ),
        ));

  void selectType(SessionType type) {
    emit(state.copyWith(session: state.session.copyWith(type: type)));
  }

  void start() {
    final nextSession = _engine.transition(state.session, TimerState.running);
    emit(state.copyWith(session: nextSession.copyWith(startTime: DateTime.now())));
    
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.session.state == TimerState.running) {
        final newElapsed = state.session.elapsed + const Duration(seconds: 1);
        if (newElapsed >= state.session.duration) {
          timer.cancel();
          _complete();
        } else {
          emit(state.copyWith(session: state.session.copyWith(elapsed: newElapsed)));
        }
      }
    });
  }

  void pause() {
    _ticker?.cancel();
    final nextSession = _engine.transition(state.session, TimerState.paused);
    emit(state.copyWith(session: nextSession));
  }

  void resume() {
    emit(state.copyWith(session: _engine.transition(state.session, TimerState.running)));
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.session.state == TimerState.running) {
        final newElapsed = state.session.elapsed + const Duration(seconds: 1);
        if (newElapsed >= state.session.duration) {
          timer.cancel();
          _complete();
        } else {
          emit(state.copyWith(session: state.session.copyWith(elapsed: newElapsed)));
        }
      }
    });
  }

  void stop() {
    _ticker?.cancel();
    final nextSession = _engine.transition(state.session, TimerState.idle);
    emit(state.copyWith(session: nextSession.copyWith(elapsed: Duration.zero)));
  }

  void _complete() {
    final nextSession = _engine.transition(state.session, TimerState.completed);
    emit(state.copyWith(session: nextSession));
    // Trigger local notification here!
  }

  @override
  Future<void> close() {
    _ticker?.cancel();
    return super.close();
  }
}
