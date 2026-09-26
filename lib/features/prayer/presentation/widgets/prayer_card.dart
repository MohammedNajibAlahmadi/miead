import 'package:flutter/material.dart';
import '../../../../shared/widgets/contextual_image_card.dart';

class PrayerCard extends StatelessWidget {
  final String prayerName;
  final String prayerTime;

  const PrayerCard({
    super.key,
    required this.prayerName,
    required this.prayerTime,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ContextualImageCard(
          assetPath: 'assets/images/prayer/prayer_makkah_01.webp',
          title: 'صلاة $prayerName',
          subtitle: prayerTime,
          semanticLabel: 'بطاقة الصلاة القادمة: صلاة $prayerName',
          onTap: () {
            // Open prayer details
          },
        ),
      ],
    );
  }
}
