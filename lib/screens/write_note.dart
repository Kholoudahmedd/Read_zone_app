import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:read_zone_app/controllers/notes_controller.dart';
import 'package:read_zone_app/themes/colors.dart';

class WriteNote extends StatefulWidget {
  final String? docId; // إذا كنت تقوم بتعديل ملاحظة موجودة في Firestore
  final Map<String, String>? note;

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
      _titleController.text = widget.note!['title']!;
      _contentController.text = widget.note!['content']!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          scrolledUnderElevation: 0,
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
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      notesController.deleteNote(widget.docId!);
                      Get.back();
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
                decoration: InputDecoration(
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
                  decoration: InputDecoration(
                    hintText: 'Type something...',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (widget.docId == null) {
              notesController.addNote(
                  _titleController.text, _contentController.text);
            } else {
              notesController.updateNote(
                  widget.docId!, _titleController.text, _contentController.text);
            }
            Get.back();
          },
          backgroundColor: getRedColor(context),
          child: Icon(Icons.check, color: Colors.white, size: 50),
          shape: CircleBorder(),
        ),
      ),
    );
  }
}
