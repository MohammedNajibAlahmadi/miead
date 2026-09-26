import '../entities/alarm.dart';
import '../../../../core/notifications/local_notifications_service.dart';

class AlarmEngine {
  final LocalNotificationsService notificationsService;

  AlarmEngine(this.notificationsService);

  Future<void> scheduleAlarm(AlarmDefinition definition, AlarmOccurrence occurrence) async {
    final id = occurrence.id.hashCode;
    await notificationsService.scheduleNotification(
      id,
      definition.title,
      'Time for your scheduled alarm',
      occurrence.scheduledAt.dateTime,
    );
  }

  Future<void> cancelAlarm(String occurrenceId) async {
    // TODO: Maintain mapped IDs for cancellation
  }
}
