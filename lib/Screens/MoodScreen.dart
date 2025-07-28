import 'package:flutter/material.dart';
// import 'package:sphere/components/MoodScreen_box.dart';
import 'package:sphere/components/mood_board.dart';
import 'package:sphere/components/navbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MoodScreen extends StatefulWidget {
  final String token;
  const MoodScreen({super.key,required this.token});

  @override
  State<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      
      body: Padding(
        padding: const EdgeInsets.only(top:10.0),
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
      bottomNavigationBar: Navbar(currentIndex: 1, onTap: (index) {}, token:widget.token,),
    );
  }
}
