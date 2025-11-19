import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gratify/models/journal_entry_model.dart';
import 'package:gratify/db/database_helper.dart';

class NoteDetailScreen extends StatelessWidget {
  final JournalEntry note;

  const NoteDetailScreen({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    // --- decode moods safely into Map<String,double> ---
    Map<String, double> moods = {};

    final dynamic raw = note.moods;

    if (raw == null) {
      moods = {};
    } else if (raw is Map) {
      moods = raw.map((k, v) {
        final doubleVal = (v is double)
            ? v
            : (v is int)
                ? v.toDouble()
                : double.tryParse(v.toString()) ?? 0.0;
        return MapEntry(k.toString(), doubleVal);
      });
    } else if (raw is String) {
      final s = raw.trim();
      try {
        final parsed = Map<String, dynamic>.from(jsonDecode(s));
        moods = parsed.map((k, v) {
          final doubleVal = (v is double)
              ? v
              : (v is int)
                  ? v.toDouble()
                  : double.tryParse(v.toString()) ?? 0.0;
          return MapEntry(k.toString(), doubleVal);
        });
      } catch (_) {
        final pairs = s.split(',');
        for (var p in pairs) {
          if (p.trim().isEmpty) continue;
          final parts = p.split(':');
          if (parts.length >= 2) {
            final key = parts[0].trim();
            final val = double.tryParse(parts[1].trim()) ?? 0.0;
            moods[key] = val;
          }
        }
      }
    }

    final formattedDate = note.date.split(' ').first;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6C468E),
        title: Text(
          "Your Note",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      // ------------------------
      // BODY CONTENT
      // ------------------------
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date
              Text(
                "Date: $formattedDate",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),

              // Note text
              Text(
                note.content,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: const Color(0xFF503160),
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 30),

              // Mood ratings
              if (moods.isNotEmpty) ...[
                Text(
                  "Mood Ratings",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF6C468E),
                  ),
                ),
                const SizedBox(height: 10),

                ...moods.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.key[0].toUpperCase() + entry.key.substring(1),
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 4),
                        LinearProgressIndicator(
                          value: entry.value / 100,
                          minHeight: 10,
                          borderRadius: BorderRadius.circular(20),
                          color: const Color(0xFF6C468E),
                          backgroundColor: Colors.grey[300],
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ],
          ),
        ),
      ),

      // ------------------------
      // BOTTOM BUTTONS (EDIT + DELETE)
      // ------------------------
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, -2),
            )
          ],
        ),
        child: Row(
          children: [
            // Edit button
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C468E),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.edit, color: Colors.white),
                label: Text(
                  "Edit",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  TextEditingController controller = TextEditingController(text: note.content);

                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        title: Text(
                          "Edit Note",
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                        ),
                        content: TextField(
                          controller: controller,
                          maxLines: 5,
                          decoration: const InputDecoration(
                            hintText: "Update your note...",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        actions: [
                          // CANCEL
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close popup only
                            },
                            child: Text(
                              "Cancel",
                              style: GoogleFonts.poppins(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          // UPDATE
                          TextButton(
                            onPressed: () async {
                              final updatedContent = controller.text.trim();

                              if (updatedContent.isEmpty) {
                                Navigator.pop(context);
                                return;
                              }

                              final updatedEntry = JournalEntry(
                                id: note.id,
                                date: note.date,
                                content: updatedContent,
                                moods: note.moods,
                              );

                              final db = DatabaseHelper.instance;
                              await db.updateNote(updatedEntry);

                              if (context.mounted) {
                                Navigator.pop(context); // close popup
                                Navigator.pop(context); // go back to previous screen

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Note updated successfully."),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            },
                            child: Text(
                              "Update",
                              style: GoogleFonts.poppins(
                                color: Color(0xFF6C468E),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(width: 12),

            // Delete button
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.delete, color: Colors.white),
                label: Text(
                  "Delete",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                onPressed: () async {
                  final db = DatabaseHelper.instance;
                  await db.deleteNote(note.id!);

                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Note deleted successfully."),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
