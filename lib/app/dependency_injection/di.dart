import 'package:get_it/get_it.dart';
import '../../core/datetime/clock.dart';
import '../../core/database/database_helper.dart';
import '../../core/notifications/local_notifications_service.dart';
import '../../features/timer/domain/services/timer_engine.dart';
import '../../features/alarms/domain/services/alarm_engine.dart';
import '../../features/alarms/data/repositories/alarm_repository.dart';
import '../../features/prayer/domain/services/prayer_engine.dart';
import '../../features/prayer/data/repositories/prayer_tracker_repository.dart';
import '../../features/prayer/presentation/bloc/prayer_tracker_cubit.dart';
import '../../features/prayer/presentation/bloc/qibla_cubit.dart';
import '../../core/notifications/notification_engine.dart';
import '../../features/statistics/data/repositories/statistics_repository.dart';
import '../../features/statistics/presentation/bloc/statistics_cubit.dart';
import '../../features/khatma/data/repositories/khatma_repository.dart';
import '../../features/khatma/presentation/bloc/khatma_cubit.dart';
import '../../features/notes/data/repositories/notes_repository.dart';
import '../../features/notes/presentation/bloc/notes_cubit.dart';
import '../../features/home/presentation/bloc/home_cubit.dart';
import '../../features/home/data/repositories/task_repository.dart';
import '../../features/settings/data/repositories/settings_repository.dart';
import '../../features/settings/presentation/bloc/settings_cubit.dart';
import '../../features/timer/presentation/bloc/focus_cubit.dart';
import '../../features/alarms/presentation/bloc/alarms_cubit.dart';
import '../../features/adhkar/data/repositories/adhkar_repository.dart';
import '../../features/adhkar/presentation/bloc/adhkar_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  final dbHelper = DatabaseHelper();
  getIt.registerLazySingleton<DatabaseHelper>(() => dbHelper);
  getIt.registerLazySingleton<AppClock>(() => SystemClock());
  
  final localNotifications = LocalNotificationsService();
  getIt.registerLazySingleton<LocalNotificationsService>(() => localNotifications);
  
  getIt.registerLazySingleton<TimerEngine>(() => TimerEngine());
  
  // Settings Layer
  getIt.registerLazySingleton<SettingsRepository>(() => SettingsRepository(getIt<DatabaseHelper>()));
  getIt.registerLazySingleton<SettingsCubit>(() => SettingsCubit(getIt<SettingsRepository>()));
  
  // Alarms Layer
  getIt.registerLazySingleton<AlarmRepository>(() => AlarmRepository(getIt<DatabaseHelper>()));
  getIt.registerLazySingleton<AlarmEngine>(() => AlarmEngine(localNotifications));
  
  // Tasks Layer
  getIt.registerLazySingleton<TaskRepository>(() => TaskRepository(getIt<DatabaseHelper>()));
  
  // Adhkar Layer
  getIt.registerLazySingleton<AdhkarRepository>(() => AdhkarRepository(getIt<DatabaseHelper>()));
  getIt.registerFactory<AdhkarCubit>(() => AdhkarCubit(getIt<AdhkarRepository>()));
  
  // Statistics Layer
  getIt.registerLazySingleton<StatisticsRepository>(() => StatisticsRepository(getIt<DatabaseHelper>()));
  getIt.registerFactory<StatisticsCubit>(() => StatisticsCubit(getIt<StatisticsRepository>()));

  // Prayer Engine & Tracking Layer
  getIt.registerLazySingleton<PrayerEngine>(() => PrayerEngine());
  getIt.registerLazySingleton<PrayerTrackerRepository>(() => PrayerTrackerRepository(getIt<DatabaseHelper>()));
  getIt.registerFactory<PrayerTrackerCubit>(() => PrayerTrackerCubit(getIt<PrayerTrackerRepository>()));
  getIt.registerFactory<QiblaCubit>(() => QiblaCubit());
  
  // OS Engines
  getIt.registerLazySingleton<NotificationEngine>(() => NotificationEngine());
  
  // Khatma Engine
  getIt.registerLazySingleton<KhatmaRepository>(() => KhatmaRepository(getIt<DatabaseHelper>()));
  getIt.registerFactory<KhatmaCubit>(() => KhatmaCubit(getIt<KhatmaRepository>()));
  
  // Notes Engine
  getIt.registerLazySingleton<NotesRepository>(() => NotesRepository(getIt<DatabaseHelper>()));
  getIt.registerFactory<NotesCubit>(() => NotesCubit(getIt<NotesRepository>()));
  
  getIt.registerFactory<HomeCubit>(() => HomeCubit(getIt<AppClock>(), getIt<PrayerEngine>(), getIt<TaskRepository>()));
  getIt.registerFactory<FocusCubit>(() => FocusCubit(getIt<TimerEngine>()));
  getIt.registerFactory<AlarmsCubit>(() => AlarmsCubit(getIt<AlarmRepository>()));
}
