import 'package:notes/features/notes/domain/entities/note.dart';
import 'package:notes/features/notes/domain/repositories/notes_repository.dart';

class GetNotesUsecase {
  final NotesRepository repository;

  GetNotesUsecase({required this.repository});

  Future<List<Note>> call() async {
    return await repository.getNotes();
  }
}

class AddNoteUsecase {
  final NotesRepository repository;

  AddNoteUsecase({required this.repository});

  Future<Note> call({required String title, required String content}) async {
    return await repository.addNote(title: title, content: content);
  }
}

class EditNoteUsecase {
  final NotesRepository repository;

  EditNoteUsecase({required this.repository});

  Future<Note> call({
    required int id,
    required String title,
    required String content,
  }) async {
    return await repository.editNote(id: id, title: title, content: content);
  }
}

class DeleteNoteUsecase {
  final NotesRepository repository;

  DeleteNoteUsecase({required this.repository});

  Future<void> call(int id) async {
    return await repository.deleteNote(id);
  }
}
