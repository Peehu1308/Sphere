import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Color(0xFFF03A47) ,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Text("Sphere",style: GoogleFonts.monsieurLaDoulaise(fontSize: 30,fontWeight: FontWeight.bold),),
            Text(
  "Sphere",
  style: GoogleFonts.pacifico(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  ),
)
,
            Text("Login",style: TextStyle(fontSize: 24),),
            TextField()
          ],
        ),
      ),
    );
  }
}