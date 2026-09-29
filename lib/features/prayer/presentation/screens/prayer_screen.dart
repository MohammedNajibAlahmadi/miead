import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/widgets/contextual_image_card.dart';
import '../bloc/prayer_tracker_cubit.dart';
import '../../domain/entities/daily_prayer_record.dart';
import '../../../../app/dependency_injection/di.dart';
import 'package:go_router/go_router.dart';

class PrayerScreen extends StatelessWidget {
  const PrayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PrayerTrackerCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الصلاة', style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () => GoRouter.of(context).push('/settings'),
              tooltip: 'إعدادات الحساب',
            )
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('مكة المكرمة', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    const Text('١٢ ربيع الأول ١٤٤٨ هـ', style: TextStyle(color: Colors.grey, fontSize: 16)),
                  ],
                ),
                const Icon(Icons.location_on, color: Colors.grey, size: 28),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => GoRouter.of(context).push('/qibla'),
              icon: const Icon(Icons.explore),
              label: const Text('بوصلة تحديد اتجاه القبلة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4AF37),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
            ),
            const SizedBox(height: 16),
            const ContextualImageCard(
              assetPath: 'assets/images/prayer/prayer_makkah_01.webp',
              title: 'صلاة العصر',
              subtitle: 'بعد ساعة و 20 دقيقة',
              semanticLabel: 'الصلاة القادمة العصر',
            ),
            const SizedBox(height: 32),
            Text('سجل الصلوات (اليوم)', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            BlocBuilder<PrayerTrackerCubit, DailyPrayerRecord>(
              builder: (context, record) {
                return Column(
                  children: [
                    _buildPrayerRow(context, 'الفجر', '04:45 ص', false, 'fajr', record.fajr),
                    _buildPrayerRow(context, 'الشروق', '06:10 ص', false, '', false, isSunrise: true),
                    _buildPrayerRow(context, 'الظهر', '12:20 م', false, 'dhuhr', record.dhuhr),
                    _buildPrayerRow(context, 'العصر', '03:45 م', true, 'asr', record.asr, isNext: true),
                    _buildPrayerRow(context, 'المغرب', '06:30 م', false, 'maghrib', record.maghrib),
                    _buildPrayerRow(context, 'العشاء', '08:00 م', false, 'isha', record.isha),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerRow(BuildContext context, String name, String time, bool isAlarmActive, String code, bool isCompleted, {bool isNext = false, bool isSunrise = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isNext ? Theme.of(context).primaryColor.withValues(alpha: 0.1) : null,
        borderRadius: BorderRadius.circular(16),
        border: isNext ? Border.all(color: Theme.of(context).primaryColor, width: 1.5) : Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          if (!isSunrise)
            Checkbox(
              value: isCompleted,
              onChanged: (val) {
                if (val != null) {
                  context.read<PrayerTrackerCubit>().togglePrayer(code, val);
                }
              },
              activeColor: const Color(0xFFD4AF37),
            )
          else 
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.0),
              child: Icon(Icons.wb_sunny_outlined, color: Colors.grey, size: 20),
            ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(name, style: TextStyle(
              fontSize: 18, 
              fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
              color: isNext ? Theme.of(context).primaryColor : null,
            )),
          ),
          Text(time, style: TextStyle(
            fontSize: 18, 
            fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
            color: isNext ? Theme.of(context).primaryColor : null,
          )),
          const SizedBox(width: 16),
          Icon(
            isAlarmActive ? Icons.notifications_active : Icons.notifications_off_outlined,
            color: isAlarmActive ? Theme.of(context).primaryColor : Colors.grey.withValues(alpha: 0.5),
            size: 22,
          ),
        ],
      ),
    );
  }
}
