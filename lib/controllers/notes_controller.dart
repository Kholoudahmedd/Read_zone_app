import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'dart:async';

class NotesController extends GetxController {
  var notes = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  StreamSubscription? _notesSubscription; // 👈 لحفظ الاشتراك

  @override
  void onInit() {
    super.onInit();
    loadNotes();
  }

  @override
  void onClose() {
    _notesSubscription?.cancel(); // 👈 أوقف الاستماع عند الإغلاق
    super.onClose();
  }

  Future<void> addNote(String title, String content) async {
    var userId = _auth.currentUser?.uid;
    if (userId == null) return;

    var newNote = {
      "title": title,
      "content": content,
      "time": DateTime.now().toLocal().toString().substring(0, 16),
      "userId": userId,
    };

    await _firestore.collection('notes').add(newNote);
    loadNotes();
  }

  void loadNotes() {
    var userId = _auth.currentUser?.uid;
    if (userId == null) {
      notes.clear();
      isLoading.value = false;
      return;
    }

    isLoading.value = true;

    _notesSubscription?.cancel();

    _notesSubscription = _firestore
        .collection('notes')
        .where('userId', isEqualTo: userId)
        .orderBy('time', descending: true)
        .snapshots()
        .listen((snapshot) {
      notes.value = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          "id": doc.id,
          "title": data['title'] ?? '',
          "content": data['content'] ?? '',
          "time": data['time'] ?? '',
        };
      }).toList();
      isLoading.value = false;
    });
  }

  Future<void> updateNote(String docId, String title, String content) async {
    var updatedNote = {
      "title": title,
      "content": content,
      "time": DateTime.now().toLocal().toString().substring(0, 16),
    };

    await _firestore.collection('notes').doc(docId).update(updatedNote);
    loadNotes();
  }

  Future<void> deleteNote(String docId) async {
    await _firestore.collection('notes').doc(docId).delete();
    loadNotes();
  }
}
