import 'package:notes/features/notes/data/datasources/notes_remote_datasource.dart';
import 'package:notes/features/notes/domain/entities/note.dart';
import 'package:notes/features/notes/domain/repositories/notes_repository.dart';

class NotesRepositoryImpl implements NotesRepository {
  final NotesRemoteDatasource remoteDatasource;

  NotesRepositoryImpl({required this.remoteDatasource});

  @override
  Future<List<Note>> getNotes() async {
    return await remoteDatasource.getNotes();
  }

  @override
  Future<Note> addNote({required String title, required String content}) async {
    return await remoteDatasource.addNote(title: title, content: content);
  }

  @override
  Future<Note> editNote({
    required int id,
    required String title,
    required String content,
  }) async {
    return await remoteDatasource.editNote(
      id: id,
      title: title,
      content: content,
    );
  }

  @override
  Future<void> deleteNote(int id) async {
    return await remoteDatasource.deleteNote(id);
  }
}
