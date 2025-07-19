import 'package:flutter/material.dart';
import 'package:sphere/components/music_box.dart';
import 'package:sphere/components/navbar.dart';

class MusicScreen extends StatelessWidget {
  final String token;
  const MusicScreen({super.key,required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Music Screen')),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Text(
                'Welcome to the Music Screen',
                style: TextStyle(fontSize: 24),
              ),
              // Here you can add your MusicBox widgets or any other content
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 10, // Example count
                itemBuilder: (context, index) {
                  return MusicBox(index: index);
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Navbar(
        currentIndex: 0,
        onTap: (index) {},
        token: token,
      ),
    );
  }
}
