import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:read_zone_app/controllers/notes_controller.dart';
import 'package:read_zone_app/themes/colors.dart';

class WriteNote extends StatefulWidget {
  final int? docId; // ID من API
  final Map<String, dynamic>? note;

  const WriteNote({super.key, this.docId, this.note});

  @override
  State<WriteNote> createState() => _WriteNoteState();
}

class _WriteNoteState extends State<WriteNote> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final NotesController notesController = Get.find<NotesController>();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!['title'] ?? '';
      _contentController.text = widget.note!['content'] ?? '';
    }
  }

  void _saveNote() async {
    String title = _titleController.text.trim();
    String content = _contentController.text.trim();

    if (title.isEmpty && content.isEmpty) {
      Get.snackbar('خطأ', 'يرجى إدخال عنوان أو محتوى');
      return;
    }

    if (widget.docId == null) {
      await notesController.addNote(title, content);
    } else {
      await notesController.updateNote(widget.docId!, title, content);
    }

    // ارجع مع إشارة إلى أن البيانات تغيّرت
    Get.back(result: true);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: getRedColor(context)),
            onPressed: () => Get.back(),
          ),
          title: Text(
            widget.docId == null ? 'Add Note' : 'Edit Note',
            style: TextStyle(
                color: getTextColor2(context), fontWeight: FontWeight.bold),
          ),
          actions: widget.docId != null
              ? [
                  IconButton(
                    icon: Icon(Icons.delete, color: getRedColor(context)),
                    onPressed: () async {
                      await notesController.deleteNote(widget.docId!);
                      Get.back(result: true);
                    },
                  )
                ]
              : null,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: getTextColor2(context)),
                decoration: const InputDecoration(
                  hintText: 'Title',
                  border: InputBorder.none,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: TextField(
                  controller: _contentController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    hintText: 'Type something...',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _saveNote,
          backgroundColor: getRedColor(context),
          child: const Icon(Icons.check, color: Colors.white, size: 50),
          shape: const CircleBorder(),
        ),
      ),
    );
  }
}
