import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/data/repo/note_repository.dart';
import 'add_note_state.dart';

class AddNoteCubit extends Cubit<AddNoteState> {
  final NoteRepository _repository;
  AddNoteCubit(this._repository) : super(AddNoteInitial());
Future<void> addNewNote({required String title, required String content}) async {
  emit(AddNoteLoading());
  try {
    await _repository.addNote(title: title, content: content); 
    emit(AddNoteSuccess());
  } catch (e) {
    emit(AddNoteError(e.toString()));
  }
}
}