import 'package:flutter/material.dart';
// import 'package:sphere/components/MoodScreen_box.dart';
import 'package:sphere/components/mood_board.dart';
import 'package:sphere/components/navbar.dart'; 
class MoodScreen extends StatefulWidget {
  const MoodScreen({super.key});

  @override
  State<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MoodScreen Screen'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Text(
                'Welcome to the MoodScreen Screen',
                style: TextStyle(fontSize: 24),
              ),
              SafeArea(child: MoodGrid())
            ],
          ),
        ),
      ),
      bottomNavigationBar: Navbar(currentIndex: 1, onTap: (index){}),
    );
  }
}