import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../db/database_helper.dart';
import '../models/journal_entry_model.dart';
import '../widgets/purple_header.dart';

//import 'dart:convert';

class AddNotesScreen extends StatefulWidget {
  final DateTime? selectedDate; //optional

  const AddNotesScreen({
    super.key,
    this.selectedDate, // not required
  }); // updated constructor

  @override
  State<AddNotesScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNotesScreen> {
  final TextEditingController _contentController = TextEditingController();
  final int _minChars = 10;
  final int _maxChars = 200;
  int _currentLen = 0;

  // Mood values (0-100)
  double happy = 0;
  double calm = 0;
  double sad = 0;
  double tired = 0;
  double angry = 0;

  @override
  void initState() {
    super.initState();
    _contentController.addListener(() {
      setState(() {
        _currentLen = _contentController.text.length;
      });
    });
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  //helper for dynamic slider color based on value
  Color _colorForValue(double value) {
    if (value < 20) return Colors.red;
    if (value < 40) return const Color.fromARGB(255, 225, 255, 0);
    if (value < 60) return const Color.fromARGB(255, 61, 241, 127);
    if (value < 80) return const Color.fromARGB(255, 86, 106, 255);
    return const Color.fromARGB(255, 235, 65, 254);
  }

  Future<void> _saveNote() async {
    print("🟣 Save Note button pressed"); //temporary
    
    final content = _contentController.text.trim();

    if (content.isEmpty) {
      _showMessage("Please write something before saving.");
      return;
    }
    if (content.length < _minChars) {
      _showMessage("Please write at least $_minChars letters.");
      return;
    }

    final moods = {
      'happy': happy,
      'calm': calm,
      'sad': sad,
      'tired': tired,
      'angry': angry,
    };

    final entry = JournalEntry(
      date: (widget.selectedDate ?? DateTime.now()).toIso8601String(),
      content: content,
      moods: moods,
    );

    await DatabaseHelper.instance.insertNote(entry);

    if (!mounted) return;

    //success dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Good Job!",
          style: GoogleFonts.poppins(
            color: const Color(0xFF6C468E),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          "Your note is saved. Come back later and take a look.",
          style: GoogleFonts.poppins(color: Colors.grey[800]),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); //close dialog
              Navigator.pop(context); // home or calendar
            },
            child: Text(
              "OK",
              style: GoogleFonts.poppins(
                color: const Color(0xFF6C468E),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  } 

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final today = widget.selectedDate ?? DateTime.now();
    final formattedDate =
        "${today.day} ${_monthName(today.month)} ${today.year}";

    return Scaffold(
      backgroundColor: const Color(0xFFF8F4FB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // purple header with rounded bottom
              const PurpleHeader(title: "Add Note"),

              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formattedDate,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF503160),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Align(
                      alignment: AlignmentGeometry.centerLeft,
                      child: Text(
                        "What are you most grateful for?",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller: _contentController,
                      maxLines: 5,
                      maxLength: _maxChars,
                      decoration: InputDecoration(
                        hintText: "Type here...",
                        hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.white,
                        counterText: "",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Color(0xFFA565C6)),
                        ),
                      ),
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "$_currentLen/$_maxChars",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: _currentLen < _minChars
                              ? Colors.red
                              : Colors.grey[600],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Rate your moods today...",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    _buildMoodSlider(
                      "😄",
                      happy,
                      (val) => setState(() => happy = val),
                    ),
                    _buildMoodSlider("😌", calm, (val) => setState(() => calm = val)),
                    _buildMoodSlider("😢", sad, (val) => setState(() => sad = val)),
                    _buildMoodSlider(
                      "🥱",
                      tired,
                      (val) => setState(() => tired = val),
                    ),
                    _buildMoodSlider(
                      "😡",
                      angry,
                      (val) => setState(() => angry = val),
                    ),

                    const SizedBox(height: 30),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Cancel button
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: const BorderSide(color: Color(0xFF6C468E)),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 18,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            "Cancel",
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF6C468E),
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                        ),

                        //Add Note button
                        ElevatedButton(
                          onPressed: _saveNote,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6C468E),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 18,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            "Add Note",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],          
          ),
        ),
      ),
    );
  }

  //Helper for each slider
  Widget _buildMoodSlider(
    String emoji,
    double value,
    Function(double) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          Expanded(
            child: Slider(
              value: value,
              min: 0,
              max: 100,
              divisions: 10,
              activeColor: _colorForValue(value),
              onChanged: onChanged,
            ),
          ),
          Text(
            "${value.round()}%",
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[800]),
          ),
        ],
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return months[month - 1];
  }
}
