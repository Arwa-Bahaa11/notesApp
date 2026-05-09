import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notes/data/Models/note_model.dart';
import 'package:notes/data/repo/note_repository.dart';
import 'package:notes/presentation/cubits/notes/get_notes/get_notes_cubit.dart';
import 'package:notes/presentation/cubits/notes/get_notes/get_notes_state.dart';

class MockNoteRepository extends Mock implements NoteRepository {}

void main() {
  late GetNotesCubit getNotesCubit;
  late MockNoteRepository mockRepo;

  setUp(() {
    mockRepo = MockNoteRepository();
    getNotesCubit = GetNotesCubit(mockRepo);
  });

  group('GetNotesCubit Tests', () {
    final mockNotes = [
      NoteModel(id: 1, title: 'Test 1', content: 'Content 1'),
      NoteModel(id: 2, title: 'Test 2', content: 'Content 2'),
    ];

    test('Initial state is GetNotesInitial', () {
      expect(getNotesCubit.state, isA<GetNotesInitial>());
    });

    blocTest<GetNotesCubit, GetNotesState>(
      'emits [Loading, Success] when fetch is successful',
      build: () {
        when(() => mockRepo.fetchNotes())
            .thenAnswer((_) async => mockNotes);
        return getNotesCubit;
      },
      act: (cubit) => cubit.fetchAllNotes(),
      expect: () => [
        isA<GetNotesLoading>(),
        isA<GetNotesSuccess>(),
      ],
    );

    blocTest<GetNotesCubit, GetNotesState>(
      'emits [Loading, Error] when fetch fails',
      build: () {
        when(() => mockRepo.fetchNotes())
            .thenThrow(Exception('Server Error'));
        return getNotesCubit;
      },
      act: (cubit) => cubit.fetchAllNotes(),
      expect: () => [
        isA<GetNotesLoading>(),
        isA<GetNotesError>(),
      ],
    );
  });
}