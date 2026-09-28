import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/dependency_injection/di.dart';
import '../../../../core/notifications/notification_engine.dart';
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

  void updateDuration(int minutes) {
    emit(state.copyWith(session: state.session.copyWith(duration: Duration(minutes: minutes))));
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
    
    getIt<NotificationEngine>().showInstantNotification(
      id: 888,
      title: 'بطل التركيز!',
      body: 'لقد أكملت أهدافك ببراعة لمدة ${state.session.duration.inMinutes} دقيقة. خذ استراحة.',
    );
  }

  @override
  Future<void> close() {
    _ticker?.cancel();
    return super.close();
  }
}
