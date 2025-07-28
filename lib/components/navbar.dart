import 'package:flutter/material.dart';
import 'package:sphere/Screens/BlogScreen.dart';
import 'package:sphere/Screens/Canvas.dart';
import 'package:sphere/Screens/MoodScreen.dart';
import 'package:sphere/Screens/MusicScreen.dart';

class Navbar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  final String token;

  const Navbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.token,
  });

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      
      currentIndex: widget.currentIndex,
      unselectedIconTheme:IconThemeData(color:Colors.grey) ,
      selectedIconTheme: IconThemeData(color: Colors.white),
      selectedLabelStyle: TextStyle(color: Colors.white),
      unselectedLabelStyle: TextStyle(color: Colors.grey),
      onTap: (index) {
        if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MusicScreen(token: widget.token),
            ),
          );
        } else if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MoodScreen(token: widget.token),
            ),
          );
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlogScreen(token: widget.token),
            ),
          );
        } else if (index == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyDrawingApp()),
          );
        }
      },
      backgroundColor: Colors.black,

      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.music_note), label: 'Music'),
        BottomNavigationBarItem(
          icon: Icon(Icons.border_all_rounded),
          label: 'Mood',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.article_outlined),
          label: 'Blog',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.draw_outlined),
          label: "Canvas",
        ),
      ],
    );
  }
}
