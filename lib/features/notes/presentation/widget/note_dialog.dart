import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/core/constants/app_colors.dart';
import 'package:notes/features/notes/domain/entities/note.dart';
import 'package:notes/features/notes/presentation/cubit/notes_cubit.dart';
import 'package:notes/features/notes/presentation/cubit/notes_state.dart';

class NoteDraftSheet extends StatefulWidget {
  final bool isEdit;
  final Note? note; // ✅ Note? مش dynamic

  const NoteDraftSheet({super.key, this.isEdit = false, this.note});

  @override
  State<NoteDraftSheet> createState() => _NoteDraftSheetState();
}

class _NoteDraftSheetState extends State<NoteDraftSheet> {
  late final TextEditingController subjectController;
  late final TextEditingController bodyController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    subjectController = TextEditingController(
      text: widget.isEdit ? widget.note!.title : "",
    );
    bodyController = TextEditingController(
      text: widget.isEdit ? widget.note!.content : "",
    );
  }

  @override
  void dispose() {
    subjectController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) {
        return BlocListener<NotesCubit, NotesState>(
          // ✅ واحد بدل MultiBlocListener
          listener: (context, state) {
            if (state is NoteAddSuccess) {
              Navigator.pop(context);
            }
          },
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Form(
                key: _formKey,
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  children: [
                    // Draggable handle
                    Center(
                      child: Container(
                        width: 50,
                        height: 5,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    // Header section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.isEdit ? "Update Note" : "New Study Note",
                          style: const TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Discard",
                                  style: TextStyle(color: Colors.grey)),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  if (widget.isEdit) {
                                    // ✅ NotesCubit بدل ManageNoteCubit
                                    context.read<NotesCubit>().editNote(
                                          widget.note!.id,
                                          subjectController.text,
                                          bodyController.text,
                                        );
                                  } else {
                                    // ✅ NotesCubit بدل AddNoteCubit
                                    context.read<NotesCubit>().addNote(
                                          subjectController.text,
                                          bodyController.text,
                                        );
                                  }
                                }
                              },
                              child: Text(
                                widget.isEdit ? "Update" : "Save",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Subject Title Input
                    TextFormField(
                      controller: subjectController,
                      validator: (value) =>
                          value == null || value.isEmpty ? "Required" : null,
                      decoration: const InputDecoration(
                        hintText: "Subject / Exam Title",
                        hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const Divider(color: Colors.grey, height: 1),
                    const SizedBox(height: 16),

                    // Body Content Input
                    TextFormField(
                      controller: bodyController,
                      validator: (value) =>
                          value == null || value.isEmpty ? "Required" : null,
                      decoration: const InputDecoration(
                        hintText: "Start organizing your thoughts here...",
                        border: InputBorder.none,
                      ),
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),

                    // Dynamic padding for the keyboard
                    SizedBox(
                        height: MediaQuery.of(context).viewInsets.bottom + 20),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
