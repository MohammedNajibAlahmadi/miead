import '../entities/timer_session.dart';

class TimerEngine {
  TimerSession transition(TimerSession session, TimerState nextState) {
    if (session.state == nextState) return session;

    switch (nextState) {
      case TimerState.prepared:
        if (session.state != TimerState.idle) return session;
        break;
      case TimerState.running:
        break;
      case TimerState.paused:
        if (session.state != TimerState.running) return session;
        break;
      case TimerState.completed:
        if (session.state != TimerState.running) return session;
        break;
      case TimerState.archived:
        if (session.state != TimerState.completed) return session;
        break;
      default:
        break;
    }
    
    return session.copyWith(state: nextState);
  }
}
