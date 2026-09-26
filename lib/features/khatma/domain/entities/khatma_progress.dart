import 'package:equatable/equatable.dart';

class KhatmaProgress extends Equatable {
  final int currentPage;
  final String surahName;
  final int totalPages = 604;

  const KhatmaProgress({
    required this.currentPage,
    required this.surahName,
  });

  double get percentage => (currentPage / totalPages) * 100;

  KhatmaProgress copyWith({
    int? currentPage,
    String? surahName,
  }) {
    return KhatmaProgress(
      currentPage: currentPage ?? this.currentPage,
      surahName: surahName ?? this.surahName,
    );
  }

  @override
  List<Object?> get props => [currentPage, surahName];
}
