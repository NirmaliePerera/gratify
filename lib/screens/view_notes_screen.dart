import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gratify/db/database_helper.dart';
import 'package:gratify/models/journal_entry_model.dart';
import 'package:table_calendar/table_calendar.dart';
import 'add_notes_screen.dart';
import 'note_detail_screen.dart';
import '../widgets/purple_header.dart';

class ViewNotesScreen extends StatefulWidget {
  const ViewNotesScreen({super.key});

  @override
  State<ViewNotesScreen> createState() => _ViewNotesScreenState();
}

class _ViewNotesScreenState extends State<ViewNotesScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  DateTime _focusedDay = DateTime.now();
  List<JournalEntry> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final notes = await _dbHelper.getAllNotes();
    setState(() => _notes = notes);
  }

  bool _hasNoteForDay(DateTime day) {
    return _notes.any((note) {
      final parsed = DateTime.tryParse(note.date);
      if (parsed == null) return false;
      return parsed.year == day.year &&
          parsed.month == day.month &&
          parsed.day == day.day;
    });
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    // Normalize both dates to date-only to avoid time zone / time-of-day issues
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selected = DateTime(
      selectedDay.year,
      selectedDay.month,
      selectedDay.day,
    );
    final isFutureDate = selected.isAfter(today);

    if (isFutureDate) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You cannot write notes for future dates."),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _focusedDay = focusedDay;
    });

    // Find note for the selected day safely
    JournalEntry? foundNote;
    for (final entry in _notes) {
      final parsed = DateTime.tryParse(entry.date);
      if (parsed == null) continue;
      if (isSameDay(parsed, selected)) {
        foundNote = entry;
        break;
      }
    }

    if (foundNote == null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddNotesScreen(selectedDate: selected),
        ),
      ).then((_) => _loadNotes());
      return;
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NoteDetailScreen(note: foundNote!),
        ),
      ).then((_) => _loadNotes());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0FA),

      body: Column(
        children: [
          const PurpleHeader(title: "Your Notes"), //Reusing the hearder

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TableCalendar(
                    focusedDay: _focusedDay,
                    firstDay: DateTime(2020),
                    lastDay: DateTime(2100),
                    calendarFormat: CalendarFormat.month,
                    selectedDayPredicate: (day) =>
                        false, // no persistent highlight
                    onDaySelected: _onDaySelected,

                    headerStyle: HeaderStyle(
                      titleCentered: true,
                      formatButtonVisible: false,
                      titleTextStyle: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF503160),
                      ),
                    ),

                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: GoogleFonts.poppins(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                      weekendStyle: GoogleFonts.poppins(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    calendarStyle: CalendarStyle(
                      todayDecoration: const BoxDecoration(
                        color: Color(0xFFDCC9F0),
                        shape: BoxShape.circle,
                      ),
                      todayTextStyle: GoogleFonts.poppins(
                        color: Color(0xFF5B2E83),
                        fontWeight: FontWeight.w700,
                      ),
                      selectedDecoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFF503160), Color(0xFFA565C6)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      markerDecoration: const BoxDecoration(
                        color: Color(0xFF6C468E),
                        shape: BoxShape.circle,
                      ),
                      outsideDaysVisible: false,
                    ),

                    calendarBuilders: CalendarBuilders(
                      markerBuilder: (context, day, events) {
                        if (_hasNoteForDay(day)) {
                          return Positioned(
                            bottom: 6,
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Color(0xFF6C468E),
                                shape: BoxShape.circle,
                              ),
                            ),
                          );
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: SizedBox(
              width: double.infinity,
              child: Image.asset(
                'assets/images/note.png',
                height: 140,
                fit: BoxFit.contain,
                alignment: Alignment.center,
                errorBuilder: (context, error, stack) => const Icon(
                  Icons.book_rounded,
                  size: 64,
                  color: Color(0xFF6C468E),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
