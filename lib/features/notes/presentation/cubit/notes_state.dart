import 'package:notes/features/notes/domain/entities/note.dart';

abstract class NotesState {}

class NotesInitial extends NotesState {}

class NotesLoading extends NotesState {}

class NotesSuccess extends NotesState {
  final List<Note> notes;
  NotesSuccess(this.notes);
}

class NotesError extends NotesState {
  final String error;
  NotesError(this.error);
}

class NoteAddSuccess extends NotesState {
  final String message;
  NoteAddSuccess(this.message);
}

class NoteDeleteSuccess extends NotesState {
  final String message;
  NoteDeleteSuccess(this.message);
}
