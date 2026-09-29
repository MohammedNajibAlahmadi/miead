import 'package:flutter/material.dart';

class WeeklyHeatmapCard extends StatelessWidget {
  final Map<String, int> weeklyActivity;

  const WeeklyHeatmapCard({super.key, required this.weeklyActivity});

  @override
  Widget build(BuildContext context) {
    // Generate last 7 days backwards
    final today = DateTime.now();
    final List<DateTime> last7Days = List.generate(7, (index) => today.subtract(Duration(days: index))).reversed.toList();
    
    // Calculate streak
    int streak = 0;
    for (int i = 0; i < 7; i++) {
      final d = today.subtract(Duration(days: i));
      final dateStr = d.toIso8601String().substring(0, 10);
      if ((weeklyActivity[dateStr] ?? 0) > 0) {
        streak++;
      } else if (i == 0) {
        // If today is 0, we don't break the streak yet, maybe they just woke up. We just ignore today for streak breaking logic.
        continue;
      } else {
        break;
      }
    }

    final weekdays = ['اثنين', 'ثلاثاء', 'أربعاء', 'خميس', 'جمعة', 'سبت', 'أحد'];

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.local_fire_department, color: Colors.orange.shade700),
                    const SizedBox(width: 8),
                    Text(
                      'الاستمرارية',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$streak أيام 🔥',
                    style: TextStyle(color: Colors.orange.shade800, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: last7Days.map((date) {
                final dateStr = date.toIso8601String().substring(0, 10);
                final focusMins = weeklyActivity[dateStr] ?? 0;
                final bool isFocused = focusMins > 0;
                
                // Color intensity logic based on duration
                Color nodeColor = Colors.grey.shade200;
                if (isFocused) {
                  if (focusMins > 120) nodeColor = const Color(0xFF1E5631); // Very dark green
                  else if (focusMins > 60) nodeColor = const Color(0xFF4C9A2A);
                  else if (focusMins > 25) nodeColor = const Color(0xFF76BA1B);
                  else nodeColor = const Color(0xFFA4DE02); // Light green
                }

                return Column(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: nodeColor,
                        shape: BoxShape.circle,
                        boxShadow: isFocused ? [
                           BoxShadow(color: nodeColor.withValues(alpha: 0.4), blurRadius: 4, offset: const Offset(0, 2))
                        ] : null,
                      ),
                      child: isFocused && focusMins > 120 
                          ? const Icon(Icons.star, color: Colors.white, size: 16) 
                          : null,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      weekdays[date.weekday - 1].substring(0, 2),
                      style: TextStyle(
                        fontSize: 12, 
                        fontWeight: isFocused ? FontWeight.bold : FontWeight.normal,
                        color: isFocused ? Theme.of(context).colorScheme.onSurface : Colors.grey,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
