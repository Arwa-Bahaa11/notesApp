import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/data/repo/note_repository.dart';
import 'get_notes_state.dart';

class GetNotesCubit extends Cubit<GetNotesState> {
  final NoteRepository _repository;
  GetNotesCubit(this._repository) : super(GetNotesInitial());

  Future<void> fetchAllNotes() async {
    emit(GetNotesLoading());
    try {
      final notes = await _repository.fetchNotes();
      emit(GetNotesSuccess(notes));
    } catch (e) {
      emit(GetNotesError(e.toString()));
    }
  }
}
