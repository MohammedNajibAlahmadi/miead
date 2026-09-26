import 'planning_advisor.dart';

class RuleBasedPlanningAdvisor implements PlanningAdvisor {
  @override
  Future<PlanningSuggestion> analyze(PlanningContext context) async {
    // Basic rules simulation step (No LLM, just deterministic)
    return PlanningSuggestion(
      context.currentPlan,
      "الخطة الحالية تسير بشكل جيد، استمر!",
    );
  }
}
