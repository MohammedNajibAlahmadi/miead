import 'package:equatable/equatable.dart';

class Dhikr extends Equatable {
  final String id;
  final String text; // Authenticated text
  final int targetCount;
  final String category; // e.g., 'morning', 'evening', 'istighfar'

  const Dhikr({
    required this.id,
    required this.text,
    required this.targetCount,
    required this.category,
  });

  @override
  List<Object?> get props => [id, text, targetCount, category];
}

class DhikrProgress extends Equatable {
  final String dhikrId;
  final int currentCount;
  final DateTime updatedAt;

  const DhikrProgress({
    required this.dhikrId,
    required this.currentCount,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [dhikrId, currentCount, updatedAt];
}
