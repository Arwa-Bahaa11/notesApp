import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/core/constants/app_colors.dart';
import 'package:notes/features/auth/presentation/pages/profile_page.dart';
import 'package:notes/features/notes/domain/entities/note.dart';
import 'package:notes/features/notes/presentation/cubit/notes_cubit.dart';
import 'package:notes/features/notes/presentation/cubit/notes_state.dart';
import 'package:notes/features/notes/presentation/widget/note_dialog.dart';
import 'package:notes/features/notes/presentation/widget/note_item.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  @override
  void initState() {
    super.initState();
    context.read<NotesCubit>().fetchNotes();
  }

  void _showNoteSheet(BuildContext context, {bool isEdit = false, Note? note}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => NoteDraftSheet(isEdit: isEdit, note: note),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scafoldBackground,
      appBar: AppBar(
        title: const Text(
          "My Notes",
          style: TextStyle(
              color: AppColors.primaryColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon:
                const Icon(Icons.person_outline, color: AppColors.primaryColor),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            ),
          ),
        ],
      ),
      body: BlocListener<NotesCubit, NotesState>(
        listener: (context, state) {
          if (state is NoteDeleteSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.primaryColor,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
          if (state is NoteAddSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.primaryColor,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: BlocBuilder<NotesCubit, NotesState>(
          builder: (context, state) {
            if (state is NotesLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is NotesSuccess) {
              if (state.notes.isEmpty) return _buildEmptyState();
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.notes.length,
                itemBuilder: (context, index) {
                  final note = state.notes[index];
                  return NoteItem(
                    note: note,
                    onEdit: () =>
                        _showNoteSheet(context, isEdit: true, note: note), // ✅
                    onDelete: () =>
                        context.read<NotesCubit>().deleteNote(note.id),
                  );
                },
              );
            }
            return const Center(
              child: Text("Error loading notes",
                  style: TextStyle(color: Colors.grey)),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: () => showDialog(
            context: context, builder: (_) => const NoteDraftSheet()),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.edit_note,
              size: 100, color: AppColors.primaryColor.withValues(alpha: 0.1)),
          const SizedBox(height: 16),
          const Text("No notes yet. Start organizing!",
              style: TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }
}
