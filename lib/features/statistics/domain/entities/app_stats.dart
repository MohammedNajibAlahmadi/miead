class AppStats {
  final int completedTasksTotal;
  final int todayFocusMinutes;
  final int totalFocusMinutes;
  final int adhkarCompleted;

  const AppStats({
    required this.completedTasksTotal,
    required this.todayFocusMinutes,
    required this.totalFocusMinutes,
    required this.adhkarCompleted,
  });

  factory AppStats.empty() {
    return const AppStats(
      completedTasksTotal: 0,
      todayFocusMinutes: 0,
      totalFocusMinutes: 0,
      adhkarCompleted: 0,
    );
  }
}
