abstract class ManageNoteState {}

class ManageNoteInitial extends ManageNoteState {}

class ManageNoteLoading extends ManageNoteState {}

class ManageNoteSuccess extends ManageNoteState {
  final String message;
  ManageNoteSuccess(this.message);
}

class ManageNoteError extends ManageNoteState {
  final String error;
  ManageNoteError(this.error);
}
