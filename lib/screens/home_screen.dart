import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
import 'set_passcode_screen.dart';
import 'add_notes_screen.dart';
import 'view_notes_screen.dart';
import 'send_feedback_screen.dart';
import '../widgets/purple_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Remove the saved passcode
  Future<void> _removePasscode(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('passcode'); // Deletes saved passcode

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Passcode removed successfully.")),
    );

    //Navigate to Set Passcode screen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SetPasscodeScreen()),
      (route) => false,
    );
  }

  //Logout (just return to login)
  void _logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  // _buildHomeButton method
  Widget _buildHomeButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: const Color(0xFFEDE7F6),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF6C468E), size: 36),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: const Color(0xFF6C468E),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0FA),

      body: Column(
        children: [
          //Purple Header Bar
          const PurpleHeader(title: "Gratify", showBack: false),

          const SizedBox(height: 20),

          // Subtitle
          Column(
            children: [
              Text(
                "Feeling grateful?",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: Colors.grey[750],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 4),
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AddNotesScreen(selectedDate: DateTime.now()),
                    ),
                  );
                },

                icon: const Icon(Icons.add, color: Color(0xFF6C468E)),
                label: Text(
                  "It's time to jot it down!",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: const Color(0xFF6C468E),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),

          //Button grid
          Wrap(
            spacing: 30,
            runSpacing: 30,
            alignment: WrapAlignment.center,
            children: [
              _buildHomeButton(
                icon: Icons.add,
                label: "Add Notes",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AddNotesScreen(selectedDate: DateTime.now()),
                    ),
                  );
                },
              ),
              _buildHomeButton(
                icon: Icons.calendar_today,
                label: "View Notes",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewNotesScreen()),
                  );
                },
              ),
              _buildHomeButton(
                icon: Icons.settings_backup_restore,
                label: "Remov\n Passcode", //Added line break
                onTap: () => _removePasscode(context),
              ),

              _buildHomeButton(
                icon: Icons.feedback_outlined,
                label: "Send\nFeedback", //Added line break
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SendFeedbackScreen(),
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Logout Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => _logout(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C468E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                child: Text(
                  "Logout",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
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
