class NoteModel {
  final int id;
  final String title;
  final String content;

  NoteModel({required this.id, required this.title, required this.content});

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
    );
  }
}