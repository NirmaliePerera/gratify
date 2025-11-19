import 'package:flutter/material.dart';
import 'dart:async'; //for timer
import 'package:google_fonts/google_fonts.dart';
import 'screens/set_passcode_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';

void main() {
  //main() -> tells Flutter where to start
  runApp(const GratifyApp()); //runApp() -> loads your main app widget
}

class GratifyApp extends StatelessWidget {
  const GratifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gratify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(), // Preload font globally
        primarySwatch: Colors.deepPurple,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateNext();
    /* // After 3s, navigate to the next screen
    Timer(const Duration(seconds: 4), () {
      //navigate to passcode later
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SetPasscodeScreen()),
      );
    });*/
  }

  Future<void> _navigateNext() async {
    await Future.delayed(const Duration(seconds: 3)); //Splash Delay
    final prefs = await SharedPreferences.getInstance();
    final hasPasscode = prefs.containsKey('passcode');

    if (!mounted) return; // safety check

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            hasPasscode ? const LoginScreen() : const SetPasscodeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF503160), Color(0xFFA565C6)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /*const SizedBox(height: 20),
              Text(
                'G',
                style: GoogleFonts.pacifico(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              Icon(
                Icons.favorite,
                color: Color.fromARGB(255, 160, 165, 73),
                size: 80,
              ),*/
              const SizedBox(height: 20),
              Text(
                'Gratify',
                style: GoogleFonts.redressed(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              /*const SizedBox(height: 8),
              Text(
                'A secure gratitude & mood journal',
                style: TextStyle(
                  fontSize: 20,
                  color: const Color.fromARGB(255, 14, 11, 16),
                  fontStyle: FontStyle.italic,
                ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}

//next screen
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Set a Passcode',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: Colors.deepPurple,
          ),
        ),
      ),
    );
  }
}

/*Use const only when:
1. All widget properties are static (e.g., plain colors, numbers, strings)
2. No runtime or function-based styling is used (like GoogleFonts or Theme.of(context))*/
