import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/features/notes/domain/usecases/notes_usecases.dart';
import 'notes_state.dart';

class NotesCubit extends Cubit<NotesState> {
  final GetNotesUsecase getNotesUsecase;
  final AddNoteUsecase addNoteUsecase;
  final EditNoteUsecase editNoteUsecase;
  final DeleteNoteUsecase deleteNoteUsecase;

  NotesCubit({
    required this.getNotesUsecase,
    required this.addNoteUsecase,
    required this.editNoteUsecase,
    required this.deleteNoteUsecase,
  }) : super(NotesInitial());

  Future<void> fetchNotes() async {
    emit(NotesLoading());
    try {
      final notes = await getNotesUsecase();
      emit(NotesSuccess(notes));
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  Future<void> addNote(String title, String content) async {
    emit(NotesLoading());
    try {
      await addNoteUsecase(title: title, content: content);
      emit(NoteAddSuccess("Note added successfully"));
      await fetchNotes();
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  Future<void> editNote(int id, String title, String content) async {
    emit(NotesLoading());
    try {
      await editNoteUsecase(id: id, title: title, content: content);
      emit(NoteAddSuccess("Note updated successfully"));
      await fetchNotes();
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  Future<void> deleteNote(int id) async {
    try {
      await deleteNoteUsecase(id);
      emit(NoteDeleteSuccess("Note deleted successfully"));
      await fetchNotes();
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }
}
