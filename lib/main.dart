import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sphere/Screens/BlogScreen.dart';
import 'package:sphere/Screens/Canvas.dart';
import 'package:sphere/Screens/MoodScreen.dart';
import 'package:sphere/Screens/MusicScreen.dart';
import 'package:sphere/Screens/SplashScreen.dart';
import 'package:sphere/components/navbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    anonKey: dotenv.env['API_Key']!,
    url: dotenv.env['Project_URL']!,
  );
  final clientId = dotenv.env['SPOTIFY_CLIENT_ID']!;
  final clientSecret = dotenv.env['SPOTIFY_CLIENT_SECRET']!;
  final redirectUri = dotenv.env['SPOTIFY_REDIRECT_URI']!;

  runApp(const MyApp(token: '',));
}

class MyApp extends StatelessWidget {
  final String token;
  const MyApp({super.key,required this.token});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: Color(0xFFF6F4F3)),
      // home: const MoodScreen(token:widget.token),
      // home: const BlogScreen(),
      home: const MainScreen(token: '',),
      // home: SplashScreen(token: '',),
      // home:MyDrawingApp()
    );
  }
}

class MainScreen extends StatefulWidget {
  final String token;
  const MainScreen({super.key,required this.token});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;
  
  late List<Widget> screens;

  @override
  void initState() {
    super.initState();
    screens = [MusicScreen(token:widget.token), MoodScreen(token:widget.token), BlogScreen(token:widget.token)];
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
