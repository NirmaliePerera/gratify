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
  DateTime? _selectedDay;
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
      final noteDate = DateTime.parse(note.date);
      return noteDate.year == day.year &&
          noteDate.month == day.month &&
          noteDate.day == day.day;
    });
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    final now = DateTime.now();
    final isFutureDate = selectedDay.isAfter(
      DateTime(now.year, now.month, now.day),
    );

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
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });

    JournalEntry? foundNote;
    try {
      foundNote = _notes.firstWhere((entry) {
        final noteDate = DateTime.parse(entry.date);
        return noteDate.year == selectedDay.year &&
            noteDate.month == selectedDay.month &&
            noteDate.day == selectedDay.day;
      });
    } catch (_) {
      foundNote = null;
    }

    if (foundNote == null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddNotesScreen(selectedDate: selectedDay),
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
                        isSameDay(_selectedDay, day),
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
                      todayDecoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF6C468E),
                          width: 2,
                        ),
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF503160),
                            Color(0xFFA565C6)
                          ],
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
        ],
      ),
    );
  }
}
