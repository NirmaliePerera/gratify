import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _PasscodeController = TextEditingController();

  bool _isPasscodeVisible = false; // Make passcode hidden by default

  Future<void> _login() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPasscode = prefs.getString('passcode');
    final entered = _PasscodeController.text.trim();
  
    if (entered.isEmpty) {
      _showMessage("Please enter your passcode.");
    } else if (entered == savedPasscode) {
      _showMessage("Welcome back! 🌸");
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      _showMessage("Incorrect passcode. Try again!");
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
    ));
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
                "Login",                 //title
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF6C468E),
                ),
              ),
              const SizedBox(height: 8),

              Text(               //subtitle
                "Login to your account using the passcode",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 40),

              Align(          //Label
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
              const SizedBox(height: 8),

              TextField(    //Passcode field
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
                  hintText: "Type here...",
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
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C468E),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    "Login",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 60),
              /* //footer icon here
              Image.asset(
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


