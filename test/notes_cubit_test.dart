import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notes/features/notes/domain/entities/note.dart';
import 'package:notes/features/notes/domain/usecases/notes_usecases.dart';
import 'package:notes/features/notes/presentation/cubit/notes_cubit.dart';
import 'package:notes/features/notes/presentation/cubit/notes_state.dart';

class MockGetNotesUsecase extends Mock implements GetNotesUsecase {}
class MockAddNoteUsecase extends Mock implements AddNoteUsecase {}
class MockEditNoteUsecase extends Mock implements EditNoteUsecase {}
class MockDeleteNoteUsecase extends Mock implements DeleteNoteUsecase {}

void main() {
  late NotesCubit notesCubit;
  late MockGetNotesUsecase mockGetNotesUsecase;
  late MockAddNoteUsecase mockAddNoteUsecase;
  late MockEditNoteUsecase mockEditNoteUsecase;
  late MockDeleteNoteUsecase mockDeleteNoteUsecase;

  setUp(() {
    mockGetNotesUsecase = MockGetNotesUsecase();
    mockAddNoteUsecase = MockAddNoteUsecase();
    mockEditNoteUsecase = MockEditNoteUsecase();
    mockDeleteNoteUsecase = MockDeleteNoteUsecase();

    notesCubit = NotesCubit(
      getNotesUsecase: mockGetNotesUsecase,
      addNoteUsecase: mockAddNoteUsecase,
      editNoteUsecase: mockEditNoteUsecase,
      deleteNoteUsecase: mockDeleteNoteUsecase,
    );
  });

  tearDown(() => notesCubit.close());

  group('fetchNotes', () {
    final tNotes = [
      Note(id: 1, title: 'Meeting', content: 'Discuss project'),
      Note(id: 2, title: 'Shopping', content: 'Buy groceries'),
    ];

    blocTest<NotesCubit, NotesState>(
      'emits [Loading, Success] when fetchNotes succeeds',
      build: () {
        when(() => mockGetNotesUsecase())
            .thenAnswer((_) async => tNotes);
        return notesCubit;
      },
      act: (cubit) => cubit.fetchNotes(),
      expect: () => [
        isA<NotesLoading>(),
        isA<NotesSuccess>(),
      ],
      verify: (_) {
        verify(() => mockGetNotesUsecase()).called(1);
      },
    );

    blocTest<NotesCubit, NotesState>(
      'emits [Loading, Error] when fetchNotes fails',
      build: () {
        when(() => mockGetNotesUsecase())
            .thenThrow(Exception('Failed to fetch'));
        return notesCubit;
      },
      act: (cubit) => cubit.fetchNotes(),
      expect: () => [
        isA<NotesLoading>(),
        isA<NotesError>(),
      ],
    );

    // ✅ الـ test الجديد
    blocTest<NotesCubit, NotesState>(
      'NotesSuccess contains correct notes data',
      build: () {
        when(() => mockGetNotesUsecase())
            .thenAnswer((_) async => tNotes);
        return notesCubit;
      },
      act: (cubit) => cubit.fetchNotes(),
      verify: (_) {
        final state = notesCubit.state as NotesSuccess;
        expect(state.notes.length, 2);
        expect(state.notes.first.title, 'Meeting');
      },
    );

  });

  // ─────────────────────────────────────────
  group('addNote', () {
    const tTitle = 'Meeting';
    const tContent = 'Discuss project architecture';

    blocTest<NotesCubit, NotesState>(
      'emits [Loading, AddSuccess] when addNote succeeds',
      build: () {
        when(() => mockAddNoteUsecase(
          title: any(named: 'title'),
          content: any(named: 'content'),
        )).thenAnswer((_) async => Future.value());

        when(() => mockGetNotesUsecase())
            .thenAnswer((_) async => []);

        return notesCubit;
      },
      act: (cubit) => cubit.addNote(tTitle, tContent),
      expect: () => [
        isA<NotesLoading>(),
        isA<NoteAddSuccess>(),
        isA<NotesLoading>(),
        isA<NotesSuccess>(),
      ],
      verify: (_) {
        verify(() => mockAddNoteUsecase(
          title: tTitle,
          content: tContent,
        )).called(1);
      },
    );

    blocTest<NotesCubit, NotesState>(
      'emits [Loading, Error] when addNote fails',
      build: () {
        when(() => mockAddNoteUsecase(
          title: any(named: 'title'),
          content: any(named: 'content'),
        )).thenThrow(Exception('Failed to add note'));
        return notesCubit;
      },
      act: (cubit) => cubit.addNote(tTitle, tContent),
      expect: () => [
        isA<NotesLoading>(),
        isA<NotesError>(),
      ],
    );
  });

  // ─────────────────────────────────────────
  group('editNote', () {
    const tId = 1;
    const tTitle = 'Updated Meeting';
    const tContent = 'Updated content';

    blocTest<NotesCubit, NotesState>(
      'emits [Loading, AddSuccess] when editNote succeeds',
      build: () {
        when(() => mockEditNoteUsecase(
          id: any(named: 'id'),
          title: any(named: 'title'),
          content: any(named: 'content'),
        )).thenAnswer((_) async => Future.value());

        when(() => mockGetNotesUsecase())
            .thenAnswer((_) async => []);

        return notesCubit;
      },
      act: (cubit) => cubit.editNote(tId, tTitle, tContent),
      expect: () => [
        isA<NotesLoading>(),
        isA<NoteAddSuccess>(),
        isA<NotesLoading>(),
        isA<NotesSuccess>(),
      ],
      verify: (_) {
        verify(() => mockEditNoteUsecase(
          id: tId,
          title: tTitle,
          content: tContent,
        )).called(1);
      },
    );

    blocTest<NotesCubit, NotesState>(
      'emits [Loading, Error] when editNote fails',
      build: () {
        when(() => mockEditNoteUsecase(
          id: any(named: 'id'),
          title: any(named: 'title'),
          content: any(named: 'content'),
        )).thenThrow(Exception('Failed to edit note'));
        return notesCubit;
      },
      act: (cubit) => cubit.editNote(tId, tTitle, tContent),
      expect: () => [
        isA<NotesLoading>(),
        isA<NotesError>(),
      ],
    );
  });

  // ─────────────────────────────────────────
  group('deleteNote', () {
    const tId = 1;

    blocTest<NotesCubit, NotesState>(
      'emits [DeleteSuccess] when deleteNote succeeds',
      build: () {
        when(() => mockDeleteNoteUsecase(tId))
            .thenAnswer((_) async => Future.value());

        when(() => mockGetNotesUsecase())
            .thenAnswer((_) async => []);

        return notesCubit;
      },
      act: (cubit) => cubit.deleteNote(tId),
      expect: () => [
        isA<NoteDeleteSuccess>(),
        isA<NotesLoading>(),
        isA<NotesSuccess>(),
      ],
      verify: (_) {
        verify(() => mockDeleteNoteUsecase(tId)).called(1);
      },
    );

    blocTest<NotesCubit, NotesState>(
      'emits [Error] when deleteNote fails',
      build: () {
        when(() => mockDeleteNoteUsecase(tId))
            .thenThrow(Exception('Failed to delete note'));
        return notesCubit;
      },
      act: (cubit) => cubit.deleteNote(tId),
      expect: () => [
        isA<NotesError>(),
      ],
    );
  });
}