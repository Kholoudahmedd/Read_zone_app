import 'package:get/get.dart';
import 'package:read_zone_app/services/notes_service.dart';

class NotesController extends GetxController {
  var notes = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotes();
  }

  Future<void> loadNotes() async {
    isLoading.value = true;
    final response = await NotesService.get('notes');
    if (response != null && response is List) {
      notes.value = List<Map<String, dynamic>>.from(response);
    }
    isLoading.value = false;
  }

  Future<void> addNote(String title, String content) async {
    await NotesService.post('notes', {
      'title': title,
      'content': content,
    });
    await loadNotes();
  }

  Future<void> updateNote(int id, String title, String content) async {
    await NotesService.put('notes/$id', {
      'title': title,
      'content': content,
    });
    await loadNotes();
  }

  Future<void> deleteNote(int id) async {
    await NotesService.delete('notes/$id');
    await loadNotes();
  }
}
