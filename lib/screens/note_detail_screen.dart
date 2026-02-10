import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gratify/models/journal_entry_model.dart';
import 'package:gratify/db/database_helper.dart';
import '../widgets/purple_header.dart';
import '../utils/mood_utils.dart';

String formatDateWithSuffix(DateTime date) {
  int day = date.day;

  String suffix;
  if (day >= 11 && day <= 13) {
    suffix = 'th';
  } else {
    switch (day % 10) {
      case 1:
        suffix = 'st';
        break;
      case 2:
        suffix = 'nd';
        break;
      case 3:
        suffix = 'rd';
        break;
      default:
        suffix = 'th';
    }
  }

  return '$day$suffix ${DateFormat('MMMM yyyy').format(date)}';
}

const Map<String, String> moodEmojis = {
  'happy': '😊',
  'sad': '😢',
  'angry': '😠',
  'calm': '😌',
  'excited': '🤩',
  'anxious': '😰',
  'tired': '😴',
};

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

    final formattedDate = formatDateWithSuffix(DateTime.parse(note.date));

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0FA),
      /*appBar: AppBar(
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
      ),*/

      // ------------------------
      // BODY CONTENT
      // ------------------------
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PurpleHeader(
              title: "Note Details",
            ), // Reusing the header for consistency
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Date
                  Text(
                    "Note added on: $formattedDate",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: const Color(0xFF6C468E),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Note text
                  Text(
                    "Your Note:",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF6C468E),
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 50),
                  Text(
                    note.content,
                    maxLines: 7, // fixed visible area
                    overflow: TextOverflow.ellipsis, // adds "..."
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: const Color.fromARGB(255, 46, 25, 57),
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 50),

                  // Mood ratings
                  if (note.moods != null && note.moods!.isNotEmpty) ...[
                    Text(
                      "Mood Ratings",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF6C468E),
                      ),
                    ),
                    const SizedBox(height: 10),

                    ...note.moods!.entries.map((entry) {
                      final moodName =
                          entry.key[0].toUpperCase() + entry.key.substring(1);
                      final emoji = moodEmojis[entry.key.toLowerCase()] ?? '🙂';
                      final value = entry.value;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Row: Emoji + Mood Name + Percentage
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '$emoji $moodName',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                Text(
                                  '${value.toInt()}%',
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    color: Colors.grey[800],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            // Color Progress Bar
                            LinearProgressIndicator(
                              value: value / 100,
                              minHeight: 10,
                              borderRadius: BorderRadius.circular(20),
                              color: colorForValue(
                                value,
                              ), // from mood_utils.dart
                              backgroundColor: Colors.grey[300],
                            ),
                          ],
                        ),
                      );
                    }),
                  ],

                  const SizedBox(height: 30),

                  // Inline action buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6C468E),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
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
                            TextEditingController controller =
                                TextEditingController(text: note.content);

                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  title: Text(
                                    "Edit Note",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                    ),
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
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "Cancel",
                                        style: GoogleFonts.poppins(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        final updatedContent = controller.text
                                            .trim();

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
                                          Navigator.pop(context);
                                          Navigator.pop(context);

                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Note updated successfully.",
                                              ),
                                              behavior:
                                                  SnackBarBehavior.floating,
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
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade600,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
