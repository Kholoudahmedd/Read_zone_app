import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:read_zone_app/screens/write_note.dart';
import 'package:read_zone_app/controllers/notes_controller.dart';

class NotesItems extends StatelessWidget {
  final NotesController notesController = Get.put(NotesController());

  NotesItems({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          scrolledUnderElevation: 0,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/My notes header.png',
                    height: 35,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),

            // Notes Container
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(50),
                    topLeft: Radius.circular(50),
                  ),
                  color: isDarkMode
                      ? const Color(0xffC86B60)
                      : const Color(0xffFFCCC6),
                ),
                child: Obx(() {
                  if (notesController.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }

                  return notesController.notes.isEmpty
                      ? Center(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/images/Group 6874.png',
                                  height:
                                      MediaQuery.of(context).size.height * 0.47,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Create your first note!',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : GridView.builder(
                          itemCount: notesController.notes.length,
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 250,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.8,
                          ),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {
                                final result = await Get.to(() => WriteNote(
                                      docId: notesController.notes[index]["id"],
                                      note: notesController.notes[index],
                                    ));
                                if (result == true) {
                                  await notesController.loadNotes();
                                }
                              },
                              child:
                                  NoteCard(note: notesController.notes[index]),
                            );
                          },
                        );
                }),
              ),
            ),
          ],
        ),

        // Floating Button to Add Notes
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await Get.to(() => const WriteNote());
            if (result == true) {
              await notesController.loadNotes();
            }
          },
          backgroundColor:
              isDarkMode ? const Color(0xffE4B5AF) : const Color(0xffFF9A8D),
          child: const Icon(Iconsax.add, size: 50, color: Colors.white),
          shape: const CircleBorder(),
        ),
      ),
    );
  }
}

// Widget for Individual Notes
class NoteCard extends StatelessWidget {
  final Map<String, dynamic> note;

  const NoteCard({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return IntrinsicHeight(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xffE4B5AF) : const Color(0xffFF9A8D),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Text(
              note["title"] ?? "",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w900,
                fontSize: 28,
                color: Colors.white,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Text(
                note["content"] ?? "",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.white,
                ),
                overflow: TextOverflow.fade,
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
