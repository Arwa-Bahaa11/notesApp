import 'package:flutter_test/flutter_test.dart';
import 'package:notes/features/notes/data/models/note_model.dart';

void main() {
  group('NoteModel', () {
    final tNoteModel = NoteModel(id: 1, title: 'Test', content: 'Test Content');

    test('Valid model from JSON', () {
      final Map<String, dynamic> jsonMap = {
        "id": 1,
        "title": "Test",
        "content": "Test Content",
      };
      final result = NoteModel.fromJson(jsonMap);
      expect(result.id, tNoteModel.id);
      expect(result.title, tNoteModel.title);
      expect(result.content, tNoteModel.content);
    });

    test('Exception when JSON types are wrong', () {
      final Map<String, dynamic> badJson = {
        "id": "not-an-int",
        "title": "Test",
        "content": "Test",
      };
      expect(() => NoteModel.fromJson(badJson), throwsA(isA<TypeError>()));
    });
  });
}