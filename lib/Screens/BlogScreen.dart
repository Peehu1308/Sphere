import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sphere/components/blog_box.dart';
import 'package:sphere/components/navbar.dart';

class BlogScreen extends StatefulWidget {
  final String token;
  const BlogScreen({super.key, required this.token});

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Positioned(
          right:2,
          child: Icon(Icons.create)),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      // appBar: AppBar(title: const Text('Blog Screen')),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 15, right: 5),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Wrap(
                    spacing: 12, // horizontal gap
                    children: List.generate(
                      6,
                      (_) => ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          "Political",
                          style: TextStyle(
                            color:
                                // Color(0xFF183059)
                                Color(0xFF235A9C),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              SafeArea(child: BlogGrid()),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Navbar(
        currentIndex: 2,
        onTap: (index) {},
        token: widget.token,
      ),
    );
  }
}
