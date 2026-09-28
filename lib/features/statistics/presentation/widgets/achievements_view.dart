import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/app_stats.dart';
import '../../../../app/dependency_injection/di.dart';
import '../../../prayer/presentation/bloc/prayer_tracker_cubit.dart';
import '../../../prayer/domain/entities/daily_prayer_record.dart';

class AchievementsView extends StatelessWidget {
  final AppStats stats;

  const AchievementsView({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PrayerTrackerCubit>(),
      child: BlocBuilder<PrayerTrackerCubit, DailyPrayerRecord>(
        builder: (context, prayerRecord) {
          final achievements = [
            _Achievement(
              title: 'في ذمة الله',
              description: 'أديت صلاة الفجر بنجاح وحافظت عليها.',
              icon: Icons.wb_twilight,
              isUnlocked: prayerRecord.fajr,
            ),
            _Achievement(
              title: 'صفوة المصلين',
              description: 'أكملت جميع الصلوات الخمس المكتوبة لهذا اليوم.',
              icon: Icons.mosque,
              isUnlocked: prayerRecord.fajr && prayerRecord.dhuhr && prayerRecord.asr && prayerRecord.maghrib && prayerRecord.isha,
            ),
            _Achievement(
              title: 'عقل لا ينام',
              description: 'تجاوزت 10 ساعات مركزة من المذاكرة والعمل.',
              icon: Icons.psychology,
              isUnlocked: stats.totalFocusMinutes >= 600,
            ),
            _Achievement(
              title: 'بطل اليوم',
              description: 'حققت أكثر من ساعتين من التركيز اليوم.',
              icon: Icons.local_fire_department,
              isUnlocked: stats.todayFocusMinutes >= 120,
            ),
            _Achievement(
              title: 'سيد المهمات',
              description: 'أكملت أكثر من 50 مهمة بنجاح.',
              icon: Icons.verified_rounded,
              isUnlocked: stats.completedTasksTotal >= 50,
            ),
            _Achievement(
              title: 'الذاكر لله',
              description: 'تجاوزت 1000 تسبيحة وذكر في عداد الأذكار.',
              icon: Icons.fingerprint,
              isUnlocked: stats.adhkarCompleted >= 1000,
            ),
          ];

          return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        final badge = achievements[index];
        return Card(
          elevation: badge.isUnlocked ? 8 : 0,
          color: badge.isUnlocked ? null : Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: badge.isUnlocked 
                ? BorderSide(color: const Color(0xFFD4AF37).withValues(alpha: 0.5), width: 2)
                : BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: badge.isUnlocked ? const Color(0xFFD4AF37).withValues(alpha: 0.2) : Colors.grey.withValues(alpha: 0.2),
                  child: Icon(
                    badge.isUnlocked ? badge.icon : Icons.lock_outline,
                    size: 40,
                    color: badge.isUnlocked ? const Color(0xFFD4AF37) : Colors.grey,
                  ),
                ),
                const Spacer(),
                Text(
                  badge.title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: badge.isUnlocked ? null : Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  badge.description,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: badge.isUnlocked ? Theme.of(context).colorScheme.primary : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
        },
      ),
    );
  }
}

class _Achievement {
  final String title;
  final String description;
  final IconData icon;
  final bool isUnlocked;

  _Achievement({required this.title, required this.description, required this.icon, required this.isUnlocked});
}
