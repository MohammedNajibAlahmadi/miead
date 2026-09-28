import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/notes_repository.dart';
import '../../domain/entities/note_entity.dart';

class NotesCubit extends Cubit<List<Note>> {
  final NotesRepository _repository;

  NotesCubit(this._repository) : super([]) {
    loadNotes();
  }

  void loadNotes() async {
    final notes = await _repository.getAllNotes();
    emit(notes);
  }

  void addNote(String title, String content, int colorCode) async {
    final newNote = Note(
      title: title.isEmpty ? 'تدوينة بدون عنوان' : title,
      content: content,
      createdAt: DateTime.now().toIso8601String(),
      colorCode: colorCode,
    );
    await _repository.addNote(newNote);
    loadNotes();
  }

  void updateNote(Note note) async {
    await _repository.updateNote(note);
    loadNotes();
  }

  void deleteNote(int id) async {
    await _repository.deleteNote(id);
    loadNotes();
  }
}
