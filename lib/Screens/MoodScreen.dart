import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sphere/Screens/Canvas.dart';
// import 'package:sphere/components/MoodScreen_box.dart';
import 'package:sphere/components/mood_board.dart';
import 'package:sphere/components/navbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MoodScreen extends StatefulWidget {
  final String token;
  const MoodScreen({super.key, required this.token});

  @override
  State<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Sphere",
              style: GoogleFonts.pacifico(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            GestureDetector(
              child: Icon(Icons.create),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyDrawingApp()),
                );
              },
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                // Text(
                //   'Welcome to the MoodScreen Screen',
                //   style: TextStyle(fontSize: 24),
                // ),
                SafeArea(child: MoodGrid()),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Navbar(
        currentIndex: 1,
        onTap: (index) {},
        token: widget.token,
      ),
    );
  }
}
