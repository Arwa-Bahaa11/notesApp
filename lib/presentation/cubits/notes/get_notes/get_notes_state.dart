import 'package:notes/data/Models/note_model.dart';

abstract class GetNotesState {}

class GetNotesInitial extends GetNotesState {}

class GetNotesLoading extends GetNotesState {}

class GetNotesSuccess extends GetNotesState {
  final List<NoteModel> notes;
  GetNotesSuccess(this.notes);
}

class GetNotesError extends GetNotesState {
  final String error;
  GetNotesError(this.error);
}
