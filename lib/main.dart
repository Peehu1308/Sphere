import 'package:flutter/material.dart';
import 'package:sphere/Screens/BlogScreen.dart';
import 'package:sphere/Screens/MoodScreen.dart';
import 'package:sphere/Screens/MusicScreen.dart';
import 'package:sphere/Screens/SplashScreen.dart';
import 'package:sphere/components/navbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFF6F4F3)
      ),
      // home: const MoodScreen(),
      // home: const BlogScreen(),
      // home: const MainScreen(),
      home:SplashScreen()
    );
  }
}
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currrentIndex = 0;
  late List<Widget> screens;

  @override
  void initState() {
    super.initState();
    screens = [
      const MusicScreen(),
      const MoodScreen(),
      const BlogScreen(),
    ];
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currrentIndex],
      bottomNavigationBar: Navbar(
        currentIndex: currrentIndex,
        onTap: (index) {
          setState(() {
            currrentIndex = index;
          });
        },
      ),
    );
  }
}