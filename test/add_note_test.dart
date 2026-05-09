import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notes/data/repo/note_repository.dart';
import 'package:notes/presentation/cubits/notes/add_note/add_note_cubit.dart';
import 'package:notes/presentation/cubits/notes/add_note/add_note_state.dart';

class MockNoteRepository extends Mock implements NoteRepository {}

void main() {
  late AddNoteCubit addNoteCubit;
  late MockNoteRepository mockRepo;

  setUp(() {
    mockRepo = MockNoteRepository();
    addNoteCubit = AddNoteCubit(mockRepo);
  });

  group('AddNoteCubit Tests', () {
    const tTitle = 'Meeting';
    const tContent = 'Discuss project architecture';

    blocTest<AddNoteCubit, AddNoteState>(
      'Note is added successfully',
      build: () {
        when(() => mockRepo.addNote(
          title: any(named: 'title'),
          content: any(named: 'content'),
        )).thenAnswer((_) async => Future.value());
        return addNoteCubit;
      },
      act: (cubit) => cubit.addNewNote(title: tTitle, content: tContent),
      expect: () => [
        isA<AddNoteLoading>(),
        isA<AddNoteSuccess>(),
      ],
      verify: (_) {
        verify(() => mockRepo.addNote(title: tTitle, content: tContent)).called(1);
      },
    );

    blocTest<AddNoteCubit, AddNoteState>(
      'Adding note fails',
      build: () {
        when(() => mockRepo.addNote(
          title: any(named: 'title'),
          content: any(named: 'content'),
        )).thenThrow(Exception('Failed to add note'));
        return addNoteCubit;
      },
      act: (cubit) => cubit.addNewNote(title: tTitle, content: tContent),
      expect: () => [
        isA<AddNoteLoading>(),
        isA<AddNoteError>(),
      ],
    );
  });
}