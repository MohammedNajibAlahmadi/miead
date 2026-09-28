import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/notes_cubit.dart';
import '../../domain/entities/note_entity.dart';
import '../../../../app/dependency_injection/di.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<NotesCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ملاحظاتي وتأملاتي', style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: BlocBuilder<NotesCubit, List<Note>>(
          builder: (context, notes) {
            if (notes.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.notes, size: 80, color: Colors.grey.withOpacity(0.3)),
                    const SizedBox(height: 16),
                    const Text('القبو فارغ! ابدأ بتدوين ملاحظاتك ويومياتك هنا.', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Color(note.colorCode), width: 1.5),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(note.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(note.content, maxLines: 3, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 12),
                        Text(
                          note.createdAt.substring(0, 10),
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                        )
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => context.read<NotesCubit>().deleteNote(note.id!),
                    ),
                    onTap: () {
                       _showNoteEditor(context, existingNote: note);
                    },
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: Builder(
          builder: (ctx) {
            return FloatingActionButton(
              onPressed: () => _showNoteEditor(ctx),
              backgroundColor: const Color(0xFFD4AF37),
              child: const Icon(Icons.draw, color: Colors.white),
            );
          }
        ),
      ),
    );
  }

  void _showNoteEditor(BuildContext context, {Note? existingNote}) {
    final titleCtrl = TextEditingController(text: existingNote?.title ?? '');
    final contentCtrl = TextEditingController(text: existingNote?.content ?? '');
    int colorCode = existingNote?.colorCode ?? 0xFF006A4E;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (bottomSheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom,
            left: 24, right: 24, top: 24
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               TextField(
                 controller: titleCtrl,
                 decoration: const InputDecoration(hintText: 'عنوان الملاحظة...', border: InputBorder.none, hintStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                 style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
               ),
               const Divider(),
               TextField(
                 controller: contentCtrl,
                 maxLines: 8,
                 decoration: const InputDecoration(hintText: 'اكتب أفكارك وملاحظاتك بطلاقة...', border: InputBorder.none),
               ),
               const SizedBox(height: 16),
               SizedBox(
                 width: double.infinity,
                 child: ElevatedButton(
                   style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4AF37), foregroundColor: Colors.white),
                   onPressed: () {
                      if (contentCtrl.text.isEmpty) return;
                      // Safe Cubit invocation
                      if (existingNote == null) {
                        context.read<NotesCubit>().addNote(titleCtrl.text, contentCtrl.text, colorCode);
                      } else {
                        context.read<NotesCubit>().updateNote(existingNote.copyWith(title: titleCtrl.text, content: contentCtrl.text));
                      }
                      Navigator.pop(bottomSheetContext);
                   },
                   child: const Text('حفظ الإدخال'),
                 ),
               ),
               const SizedBox(height: 24),
            ],
          ),
        );
      }
    );
  }
}
