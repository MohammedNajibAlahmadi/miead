import 'package:equatable/equatable.dart';

class Note extends Equatable {
  final int? id;
  final String title;
  final String content;
  final String createdAt;
  final int colorCode;

  const Note({
    this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.colorCode,
  });

  Note copyWith({int? id, String? title, String? content, String? createdAt, int? colorCode}) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      colorCode: colorCode ?? this.colorCode,
    );
  }

  @override
  List<Object?> get props => [id, title, content, createdAt, colorCode];
}
