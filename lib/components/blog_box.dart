import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class BlogBox extends StatelessWidget {
  final String text;
  final Color color;

  const BlogBox({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
      margin: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color,
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
      ),
    );
  }
}

class BlogGrid extends StatelessWidget {
  BlogGrid({super.key});

  final List<String> blogTexts = [
    "Short blog",
    "This is a bit longer blog to see how height works",
    "Another blog with more content. Flutter makes it super easy to build responsive UIs. Just check this out!",
    "Tiny post",
    "One more example of a blog card with random height depending on how much text it has.Another blog with more content. Flutter makes it super easy to build responsive UIs. Just check this out!",
    "Another blog with more content. Flutter makes it super easy to build responsive UIs. Just check this out!",
    "Tiny post",
    "One more example of a blog card with random height depending on how much text it has.",
    "Another blog with more content. Flutter makes it super easy to build responsive UIs. Just check this out!",
    "Tiny post",
    "One more example of a blog card with random height depending on how much text it has.",
    "Another blog with more content. Flutter makes it super easy to build responsive UIs. Just check this out!",
    "Tiny post",
    "One more example of a blog card with random height depending on how much text it has.",
  ];

  final List<Color> blogColors = [
    const Color(0xFF183059),
    const Color(0xFF235A9C),
    const Color(0xFF276FBF),
    const Color(0xFF2F394D),
    const Color(0xFF0A2463),
  ];

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 3,
      crossAxisSpacing: 2,
      padding: const EdgeInsets.all(8),
      itemCount: blogTexts.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final color = blogColors[index % blogColors.length];
        return BlogBox(text: blogTexts[index], color: color);
      },
    );
  }
}
