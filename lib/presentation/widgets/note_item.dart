// شيلنا الـ underscore من هنا
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/presentation/cubits/notes/manage_note/manage_note_cubit.dart';

class NoteItem extends StatelessWidget { 
  final dynamic note;
  final VoidCallback onEdit;
  
  const NoteItem({super.key, required this.note, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: ListTile(
        onTap: onEdit, 
        title: Text(note.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(note.content, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
          onPressed: () {
            context.read<ManageNoteCubit>().deleteNote(note.id);
          },
        ),
      ),
    );
  }
}