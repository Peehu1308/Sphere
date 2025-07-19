import 'package:flutter/material.dart';
import 'package:sphere/components/blog_box.dart';
import 'package:sphere/components/navbar.dart';

class BlogScreen extends StatefulWidget {
  final String token;
  const BlogScreen({super.key,required this.token});

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Blog Screen')),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Text(
                'Welcome to the Blog Screen',
                style: TextStyle(fontSize: 24),
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
