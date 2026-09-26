import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/statistics_repository.dart';
import '../../domain/entities/app_stats.dart';

class StatisticsCubit extends Cubit<AppStats> {
  final StatisticsRepository _repository;

  StatisticsCubit(this._repository) : super(AppStats.empty()) {
    loadStats();
  }

  void loadStats() async {
    final stats = await _repository.fetchStats();
    emit(stats);
  }
}
