import 'package:flutter/material.dart';

class BlogData extends StatefulWidget {
  final String text;
  final Image image;
  const BlogData({super.key, required this.text, required this.image});

  @override
  State<BlogData> createState() => _BlogDataState();
}

class _BlogDataState extends State<BlogData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column(children: [
      widget.image,
      Text(widget.text,)
      
    ]));
  }
}
