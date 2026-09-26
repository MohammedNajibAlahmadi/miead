import '../../features/daily_plan/domain/entities/daily_plan.dart';

class PlanningContext {
  final DailyPlan currentPlan;
  final DateTime currentTime;

  PlanningContext(this.currentPlan, this.currentTime);
}

class PlanningSuggestion {
  final DailyPlan suggestedPlan;
  final String reason;

  PlanningSuggestion(this.suggestedPlan, this.reason);
}

abstract interface class PlanningAdvisor {
  Future<PlanningSuggestion> analyze(PlanningContext context);
}
