import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/presentation/cubits/notes/add_note/add_note_cubit.dart';
import 'package:notes/presentation/cubits/notes/add_note/add_note_state.dart';
import 'package:notes/presentation/cubits/notes/get_notes/get_notes_cubit.dart';
import 'package:notes/presentation/cubits/notes/get_notes/get_notes_state.dart';
import 'package:notes/presentation/cubits/notes/manage_note/manage_note_cubit.dart';
import 'package:notes/presentation/cubits/notes/manage_note/manage_note_state.dart';
import 'package:notes/presentation/pages/profile_page.dart';
import 'package:notes/presentation/widgets/note_item.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  @override
  void initState() {
    super.initState();
    context.read<GetNotesCubit>().fetchAllNotes();
  }

  void _showNoteDialog(BuildContext context,
      {bool isEdit = false, dynamic note}) {
    final titleController =
        TextEditingController(text: isEdit ? note.title : "");
    final contentController =
        TextEditingController(text: isEdit ? note.content : "");

    showDialog(
      context: context,
      builder: (context) => MultiBlocListener(
        listeners: [
          BlocListener<AddNoteCubit, AddNoteState>(
            listener: (context, state) {
              if (state is AddNoteSuccess) {
                Navigator.pop(context);
                context.read<GetNotesCubit>().fetchAllNotes();
              }
            },
          ),
          BlocListener<ManageNoteCubit, ManageNoteState>(
            listener: (context, state) {
              if (state is ManageNoteSuccess) {
                Navigator.pop(context);
                context.read<GetNotesCubit>().fetchAllNotes();
              }
            },
          ),
        ],
        child: AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(isEdit ? "Edit Note" : "Add New Note",
              style: const TextStyle(
                  color: Color(0xFF2D2A70), fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                    hintText: "Title", border: InputBorder.none),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Divider(),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(
                    hintText: "Start typing...", border: InputBorder.none),
                maxLines: 5,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2D2A70),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    contentController.text.isNotEmpty) {
                  if (isEdit) {
                    context.read<ManageNoteCubit>().updateNote(
                        note.id, titleController.text, contentController.text);
                  } else {
                    context.read<AddNoteCubit>().addNewNote(
                        title: titleController.text,
                        content: contentController.text);
                  }
                }
              },
              child: Text(isEdit ? "Update" : "Save",
                  style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFF),
      appBar: AppBar(
        title: const Text(
          "My Notes",
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: Color(0xFF2D2A70)),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ProfilePage()));
            },
          ),
        ],
      ),
      body: BlocListener<ManageNoteCubit, ManageNoteState>(
        listener: (context, state) {
          if (state is ManageNoteSuccess) {
            context.read<GetNotesCubit>().fetchAllNotes();
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: BlocBuilder<GetNotesCubit, GetNotesState>(
          builder: (context, state) {
            if (state is GetNotesLoading)
              return const Center(child: CircularProgressIndicator());
            if (state is GetNotesSuccess) {
              if (state.notes.isEmpty) return _buildEmptyState();
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.notes.length,
                itemBuilder: (context, index) {
                  final note = state.notes[index];
                  return NoteItem(
                    note: note,
                    onEdit: () =>
                        _showNoteDialog(context, isEdit: true, note: note),
                  );
                },
              );
            }
            return const Center(child: Text("Error loading notes"));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2D2A70),
        onPressed: () => _showNoteDialog(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.edit_note, size: 100, color: Colors.grey),
          Text("No notes found.", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
