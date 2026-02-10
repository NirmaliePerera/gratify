import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/purple_header.dart';

class SendFeedbackScreen extends StatelessWidget {
  const SendFeedbackScreen({super.key});

  Future<void> _openEmailApp(BuildContext context) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'gratify.app.feedback@gmail.com',
      queryParameters: const {
        'subject': 'App Feedback',
        'body': 'Hello, I would like to share...',
      },
    );

    final canLaunch = await canLaunchUrl(emailUri);
    if (!canLaunch) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No email app found on this device.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final launched = await launchUrl(
      emailUri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open the email app.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PurpleHeader(title: "Send Feedback"),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),

                  // MAIN TEXT
                  const Text(
                    "We value your feedback! Please reach out to us via email or phone.",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 32),
                  // PHONE NUMBER 1
                  GestureDetector(
                    onTap: () => _callNumber("0712345678"),
                    child: Row(
                      children: const [
                        Icon(Icons.phone, size: 24),
                        SizedBox(width: 10),
                        Text("071 234 5678", style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // PHONE NUMBER 2
                  GestureDetector(
                    onTap: () => _callNumber("0779876543"),
                    child: Row(
                      children: const [
                        Icon(Icons.phone, size: 24),
                        SizedBox(width: 10),
                        Text("077 987 6543", style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // OPEN EMAIL BUTTON
                  ElevatedButton.icon(
                    onPressed: () => _openEmailApp(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6C468E),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.email_outlined),
                    label: const Text("Open Email App"),
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
