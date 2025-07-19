import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sphere/Screens/BlogScreen.dart';
import 'package:sphere/Screens/MoodScreen.dart';
import 'package:sphere/Screens/MusicScreen.dart';
import 'package:sphere/Screens/SplashScreen.dart';
import 'package:sphere/components/navbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


Future<void>main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName:".env");
  await Supabase.initialize(
    anonKey:dotenv.env['API_Key']!, 
    url: dotenv.env['Project_URL']!);
  
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
      home: const MoodScreen(),
      // home: const BlogScreen(),
      // home: const MainScreen(),
      // home:SplashScreen()
    );
  }
}
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;
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
      body: screens[currentIndex],
      // bottomNavigationBar: Navbar(
      //   currentIndex: currentIndex,
      //   onTap: (index) {
      //     setState(() {
      //       currentIndex = index;
      //     });
      //   },
      // ),
    );
  }
}