import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notes/features/notes/domain/entities/note.dart';
import 'package:notes/features/notes/domain/repositories/notes_repository.dart';
import 'package:notes/features/notes/domain/usecases/notes_usecases.dart';

class MockNotesRepository extends Mock implements NotesRepository {}

void main() {
  late MockNotesRepository mockRepo;
  late GetNotesUsecase getNotesUsecase;
  late AddNoteUsecase addNoteUsecase;
  late EditNoteUsecase editNoteUsecase;
  late DeleteNoteUsecase deleteNoteUsecase;

  setUp(() {
    mockRepo = MockNotesRepository();
    getNotesUsecase = GetNotesUsecase(repository: mockRepo);
    addNoteUsecase = AddNoteUsecase(repository: mockRepo);
    editNoteUsecase = EditNoteUsecase(repository: mockRepo);
    deleteNoteUsecase = DeleteNoteUsecase(repository: mockRepo);
  });

  final tNote = Note(id: 1, title: 'Test Title', content: 'Test Content');
  final tNotesList = [tNote];

  test('Get Notes', () async {
      when(() => mockRepo.getNotes()).thenAnswer((_) async => tNotesList);
      final result = await getNotesUsecase.call();
      expect(result, tNotesList);
      verify(() => mockRepo.getNotes()).called(1);
  });

  test('Add a note', () async {
      when(() => mockRepo.addNote(
        title: any(named: 'title'),
        content: any(named: 'content'),
      )).thenAnswer((_) async => tNote);
      final result = await addNoteUsecase.call(title: 'Test Title', content: 'Test Content');
      expect(result, tNote);
      verify(() => mockRepo.addNote(title: 'Test Title', content: 'Test Content')).called(1);
  });

  test('Edit on a note', () async {
      when(() => mockRepo.editNote(
        id: any(named: 'id'),
        title: any(named: 'title'),
        content: any(named: 'content'),
      )).thenAnswer((_) async => tNote);
      final result = await editNoteUsecase.call(id: 1, title: 'New Title', content: 'New Content');
      expect(result, tNote);
      verify(() => mockRepo.editNote(id: 1, title: 'New Title', content: 'New Content')).called(1);
  });

  test('Delete a note', () async {
      when(() => mockRepo.deleteNote(any())).thenAnswer((_) async => Future<void>.value());
      await deleteNoteUsecase.call(1);
      verify(() => mockRepo.deleteNote(1)).called(1);
  });
}