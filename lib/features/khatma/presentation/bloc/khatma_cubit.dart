import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/khatma_repository.dart';
import '../../domain/entities/khatma_progress.dart';

class KhatmaCubit extends Cubit<KhatmaProgress> {
  final KhatmaRepository _repository;

  KhatmaCubit(this._repository) : super(const KhatmaProgress(currentPage: 1, surahName: 'الفاتحة')) {
    _loadData();
  }

  void _loadData() async {
    final progress = await _repository.getProgress();
    emit(progress);
  }

  void addPages(int count) async {
    int newPage = state.currentPage + count;
    if (newPage > 604) newPage = 604;
    if (newPage < 1) newPage = 1;
    
    // Simple heuristic to name surahs based on page blocks (Mock for simplicity)
    String surah = 'البقرة';
    if (newPage > 50) surah = 'آل عمران';
    if (newPage > 100) surah = 'النساء';
    if (newPage > 200) surah = 'يونس';
    if (newPage > 400) surah = 'يس';
    if (newPage > 500) surah = 'الملك';
    if (newPage > 590) surah = 'جزء عمّ';
    if (newPage == 1) surah = 'الفاتحة';
    
    await _repository.updateProgress(newPage, surah);
    emit(state.copyWith(currentPage: newPage, surahName: surah));
  }
}
