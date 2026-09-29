class AppStats {
  final int completedTasksTotal;
  final int todayFocusMinutes;
  final int totalFocusMinutes;
  final int adhkarCompleted;
  final Map<String, int> focusDistribution;
  final Map<String, int> weeklyActivity;

  const AppStats({
    required this.completedTasksTotal,
    required this.todayFocusMinutes,
    required this.totalFocusMinutes,
    required this.adhkarCompleted,
    this.focusDistribution = const {},
    this.weeklyActivity = const {},
  });

  AppStats copyWith({
    int? completedTasksTotal,
    int? todayFocusMinutes,
    int? totalFocusMinutes,
    int? adhkarCompleted,
    Map<String, int>? focusDistribution,
    Map<String, int>? weeklyActivity,
  }) {
    return AppStats(
      completedTasksTotal: completedTasksTotal ?? this.completedTasksTotal,
      todayFocusMinutes: todayFocusMinutes ?? this.todayFocusMinutes,
      totalFocusMinutes: totalFocusMinutes ?? this.totalFocusMinutes,
      adhkarCompleted: adhkarCompleted ?? this.adhkarCompleted,
      focusDistribution: focusDistribution ?? this.focusDistribution,
      weeklyActivity: weeklyActivity ?? this.weeklyActivity,
    );
  }

  factory AppStats.empty() {
    return const AppStats(
      completedTasksTotal: 0,
      todayFocusMinutes: 0,
      totalFocusMinutes: 0,
      adhkarCompleted: 0,
      focusDistribution: const {},
    );
  }
}
