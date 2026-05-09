import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notes/features/notes/data/datasources/notes_remote_datasource.dart';
import 'package:notes/features/notes/data/models/note_model.dart';
import 'package:notes/features/notes/data/repositories/notes_repository_impl.dart';

class MockNotesRemoteDataSource extends Mock implements NotesRemoteDatasource {}

void main() {
  late NotesRepositoryImpl repository;
  late MockNotesRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockNotesRemoteDataSource();
    repository = NotesRepositoryImpl(remoteDatasource: mockRemoteDataSource);
  });

  final tNoteModel = NoteModel(id: 1, title: 'Test', content: 'Test Content');
  final tNotesList = [tNoteModel];

  group('getNotes', () {
    test('should return list of notes when remote call is successful', () async {
      when(() => mockRemoteDataSource.getNotes())
          .thenAnswer((_) async => tNotesList);
      final result = await repository.getNotes();
      expect(result, equals(tNotesList));
      verify(() => mockRemoteDataSource.getNotes()).called(1);
    });
  });

  group('addNote', () {
    test('should call remote data source to add a note', () async {
      when(() => mockRemoteDataSource.addNote(
        title: any(named: 'title'),
        content: any(named: 'content'),
      )).thenAnswer((_) async => tNoteModel);
      final result = await repository.addNote(
        title: 'Test',
        content: 'Test Content',
      );
      expect(result, equals(tNoteModel));
      verify(() => mockRemoteDataSource.addNote(
        title: 'Test',
        content: 'Test Content',
      )).called(1);
    });
  });

  group('deleteNote', () {
    test('should call remote data source to delete a note', () async {
      when(() => mockRemoteDataSource.deleteNote(any()))
          .thenAnswer((_) async => Future.value());
      await repository.deleteNote(1);
      verify(() => mockRemoteDataSource.deleteNote(1)).called(1);
    });
  });
}