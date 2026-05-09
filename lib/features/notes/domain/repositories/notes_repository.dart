import 'package:notes/features/notes/domain/entities/note.dart';

abstract class NotesRepository {
  Future<List<Note>> getNotes();
  Future<Note> addNote({required String title, required String content});
  Future<Note> editNote({
    required int id,
    required String title,
    required String content,
  });
  Future<void> deleteNote(int id);
}
