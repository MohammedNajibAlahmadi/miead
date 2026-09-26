import 'package:flutter_test/flutter_test.dart';
import 'package:miead/features/timer/domain/entities/timer_session.dart';
import 'package:miead/features/timer/domain/services/timer_engine.dart';

void main() {
  test('TimerEngine transitions state correctly', () {
    final engine = TimerEngine();
    var session = const TimerSession(
      id: '1',
      type: SessionType.work,
      duration: Duration(minutes: 25),
    );

    expect(session.state, TimerState.idle);

    session = engine.transition(session, TimerState.prepared);
    expect(session.state, TimerState.prepared);

    session = engine.transition(session, TimerState.running);
    expect(session.state, TimerState.running);

    session = engine.transition(session, TimerState.paused);
    expect(session.state, TimerState.paused);

    session = engine.transition(session, TimerState.running);
    expect(session.state, TimerState.running);

    session = engine.transition(session, TimerState.completed);
    expect(session.state, TimerState.completed);

    session = engine.transition(session, TimerState.archived);
    expect(session.state, TimerState.archived);
  });
}
