import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final String id;
  final String title;
  final bool isCompleted;
  final Duration estimatedDuration;

  const Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.estimatedDuration = const Duration(minutes: 30),
  });

  @override
  List<Object?> get props => [id, title, isCompleted, estimatedDuration];
}
