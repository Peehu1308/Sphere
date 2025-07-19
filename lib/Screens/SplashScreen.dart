import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sphere/Screens/MoodScreen.dart';
import 'package:sphere/components/spotify.dart';
import 'package:sphere/main.dart';

class SplashScreen extends StatefulWidget {
  final String token;
  const SplashScreen({super.key, required this.token});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MoodScreen(token: widget.token),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCA1551),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Sphere",
              style: GoogleFonts.monsieurLaDoulaise(
                fontSize: 80,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Your Mood. Your Music. Your Words.",
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final token = await authenticateWithSpotify();

                if (token != null) {
                  // ✅ Navigate to MainScreen AFTER token is ready
                  // Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => MainScreen(token: token),
                  //   ),
                  // );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Spotify login failed")),
                  );
                }
              },
              child: const Text('Login with Spotify'),
            ),
          ],
        ),
      ),
    );
  }
}
