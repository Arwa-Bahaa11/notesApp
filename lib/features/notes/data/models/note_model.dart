import 'package:notes/features/notes/domain/entities/note.dart';

class NoteModel extends Note {
  NoteModel({
    required int id,
    required String title,
    required String content,
  }) : super(id: id, title: title, content: content);

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
    };
  }
}
