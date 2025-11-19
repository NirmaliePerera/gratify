import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SendFeedbackScreen extends StatelessWidget {
  const SendFeedbackScreen({super.key});

  Future<void> _openEmailApp() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'gratify.app.feedback@gmail.com', 
      query: 'subject=App Feedback&body=Hello, I would like to share...',
    );

    if (await canLaunchUrl(emailUri)) {
    await launchUrl(emailUri, mode: LaunchMode.externalApplication);
  } else {
    debugPrint("Could not launch email");
  }
  }

  // Call phone number
  void _callNumber(String number) async {
    final Uri telUri = Uri(scheme: 'tel', path: number);
    await launchUrl(telUri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Send Feedback"),
        backgroundColor: Color(0xFF6C468E),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // MAIN TEXT
            const Text(
              "We value your feedback! Please reach out to us via email or phone.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),
            // PHONE NUMBER 1
            GestureDetector(
              onTap: () => _callNumber("0712345678"),
              child: Row(
                children: const [
                  Icon(Icons.phone, size: 24),
                  SizedBox(width: 10),
                  Text(
                    "071 234 5678",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // PHONE NUMBER 2
            GestureDetector(
              onTap: () => _callNumber("0779876543"),
              child: Row(
                children: const [
                  Icon(Icons.phone, size: 24),
                  SizedBox(width: 10),
                  Text(
                    "077 987 6543",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),

            const Spacer(),
            
            // OPEN EMAIL BUTTON
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _openEmailApp,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6C468E),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            child: const Text("Open Email App"),
            ),
          ],
        ),
      )
    );
  }
}
