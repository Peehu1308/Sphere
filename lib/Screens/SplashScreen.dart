import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sphere/components/spotify.dart';
import 'package:sphere/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
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
            ElevatedButton(
  onPressed: () {
    authenticateWithSpotify();
  },
  child: const Text('Login with Spotify'),
)

          ],
        ),
      ),
    );
  }
}
