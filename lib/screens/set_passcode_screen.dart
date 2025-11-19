import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

class SetPasscodeScreen extends StatefulWidget {
  const SetPasscodeScreen({super.key});

  @override
  State<SetPasscodeScreen> createState() => _SetPasscodeScreenState();
}

class _SetPasscodeScreenState extends State<SetPasscodeScreen> {
  final TextEditingController _PasscodeController = TextEditingController();

  bool _isPasscodeVisible = false; // Make passcode hidden by default

  void _confirmPasscode() async {
    final passcode = _PasscodeController.text.trim();

    if (passcode.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter a passcode.")));
    } else if (passcode.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passcode must be at least 6 digits.")),
      );
    } else if (passcode.length > 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passcode cannot exceed 8 digits.")),
      );
    } else {
      //save encrypted passcode in local storage(later)
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('passcode', passcode);

      //Show Confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passcode set successfully!")),
      );

      //Navigate to Login screen
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Set a Passcode",
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF6C468E),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Your thoughts are personal — keep them safe with a passcode",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 40),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Enter Passcode",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Passcode must be 6-8 digits long.",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _PasscodeController,
                obscureText: !_isPasscodeVisible,
                keyboardType: TextInputType.number,
                maxLength: 8,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, //  allows only 0–9
                ],
                decoration: InputDecoration(
                  counterText: "",
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "E.g, 123456",
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  //suffixIcon for show/hide feature
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasscodeVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: const Color(0xFF6C468E),
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasscodeVisible = !_isPasscodeVisible;
                      });
                    },
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                      color: Color(0xFFA565C6),
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                      color: Color(0xFF6C468E),
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _confirmPasscode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C468E),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    "Confirm Password",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              /*Image.asset(
                'assets/logo.png',
                height: 50,
              )*/
            ],
          ),
        ),
      ),
    );
  }
}
