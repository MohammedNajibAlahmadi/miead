import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/statistics_cubit.dart';
import '../../domain/entities/app_stats.dart';
import '../widgets/achievements_view.dart';
import '../widgets/fractal_tree.dart';
import '../widgets/focus_distribution_chart.dart';
import '../widgets/weekly_heatmap_card.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الإحصائيات والأوسمة'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'الأرقام', icon: Icon(Icons.bar_chart)),
              Tab(text: 'الأوسمة والجوائز', icon: Icon(Icons.military_tech)),
            ],
          ),
        ),
        body: BlocBuilder<StatisticsCubit, AppStats>(
          builder: (context, stats) {
            return TabBarView(
              children: [
                // Tab 1: Numbers
                ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    WeeklyHeatmapCard(weeklyActivity: stats.weeklyActivity),
                    const SizedBox(height: 16),
                    FractalTree(focusMinutes: stats.totalFocusMinutes),
                    const SizedBox(height: 16),
                    FocusDistributionChart(distribution: stats.focusDistribution),
                    const SizedBox(height: 24),
                    _buildStatCard(
                      context,
                      title: 'المهام المنجزة',
                      value: stats.completedTasksTotal.toString(),
                      icon: Icons.task_alt,
                      color: const Color(0xFF006A4E),
                    ),
                    const SizedBox(height: 16),
                    _buildStatCard(
                      context,
                      title: 'دقائق التركيز (اليوم)',
                      value: '${stats.todayFocusMinutes} دقيقة',
                      icon: Icons.timer,
                      color: const Color(0xFFD4AF37),
                    ),
                    const SizedBox(height: 16),
                    _buildStatCard(
                      context,
                      title: 'إجمالي دقائق التركيز',
                      value: '${stats.totalFocusMinutes} دقيقة',
                      icon: Icons.access_time_filled,
                      color: Colors.blueGrey,
                    ),
                    const SizedBox(height: 16),
                    _buildStatCard(
                      context,
                      title: 'معدل الأذكار المحفوظة',
                      value: stats.adhkarCompleted.toString(),
                      icon: Icons.fingerprint,
                      color: Colors.teal,
                    ),
                  ],
                ),
                // Tab 2: Gamification (AchievementsView)
                AchievementsView(stats: stats),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, {required String title, required String value, required IconData icon, required Color color}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.1),
              radius: 30,
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey.shade600)),
                  const SizedBox(height: 8),
                  Text(value, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: color)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
