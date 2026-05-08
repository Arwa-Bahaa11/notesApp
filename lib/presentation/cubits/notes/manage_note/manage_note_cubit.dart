import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/data/repo/note_repository.dart';
import 'manage_note_state.dart';

class ManageNoteCubit extends Cubit<ManageNoteState> {
  final NoteRepository _repository;
  ManageNoteCubit(this._repository) : super(ManageNoteInitial());

  Future<void> updateNote(int id, String title, String content) async {
    emit(ManageNoteLoading());
    try {
      await _repository.editNote(
        id: id,
        title: title,
        content: content,
      );
      emit(ManageNoteSuccess("تم التعديل بنجاح"));
    } catch (e) {
      emit(ManageNoteError(e.toString()));
    }
  }

  Future<void> deleteNote(int id) async {
    emit(ManageNoteLoading());
    try {
      await _repository.deleteNote(id);
      emit(ManageNoteSuccess("تم الحذف بنجاح"));
    } catch (e) {
      emit(ManageNoteError(e.toString()));
    }
  }
}
