import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/adhkar_repository.dart';

class AdhkarState {
  final List<AdhkarItem> availableAdhkar;
  final AdhkarItem? currentItem;
  final int count;
  final bool isCompleted;

  AdhkarState({
    this.availableAdhkar = const [],
    this.currentItem,
    this.count = 0,
    this.isCompleted = false,
  });

  AdhkarState copyWith({List<AdhkarItem>? availableAdhkar, AdhkarItem? currentItem, int? count, bool? isCompleted}) {
    return AdhkarState(
      availableAdhkar: availableAdhkar ?? this.availableAdhkar,
      currentItem: currentItem ?? this.currentItem,
      count: count ?? this.count,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class AdhkarCubit extends Cubit<AdhkarState> {
  final AdhkarRepository _repository;

  AdhkarCubit(this._repository) : super(AdhkarState()) {
    _loadAll();
  }

  Future<void> _loadAll() async {
    final items = await _repository.getAllAdhkar();
    if (items.isNotEmpty) {
      emit(state.copyWith(
        availableAdhkar: items,
        currentItem: items.first,
        count: 0,
        isCompleted: false,
      ));
    }
  }

  void selectAdhkar(AdhkarItem item) {
    emit(state.copyWith(currentItem: item, count: 0, isCompleted: false));
  }

  void increment() {
    if (state.currentItem != null && state.count < state.currentItem!.target) {
      final newCount = state.count + 1;
      emit(state.copyWith(
        count: newCount,
        isCompleted: newCount >= state.currentItem!.target,
      ));
    }
  }

  void reset() {
    emit(state.copyWith(count: 0, isCompleted: false));
  }
}
