import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MoodBoardBox extends StatelessWidget {
  final String text;
  final Color color;

  const MoodBoardBox({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      margin: const EdgeInsets.all(3.0),
      padding: const EdgeInsets.symmetric(
        vertical: 3.0,
        horizontal: 12.0,
      ), // Inner padding
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
          height: 1.4, // Line height for better spacing
        ),
      ),
    );
  }
}

class MoodGrid extends StatelessWidget {
  MoodGrid({super.key});

  final List<String> blogTexts = [
    "Short blog",
    "This is a bit longer blog to see how height works",
    "Another blog with more content. Flutter makes it super easy to build responsive UIs. Just check this out!,Another blog with more content. Flutter makes it super easy to build responsive UIs. Just check this out!",
    "Tiny post",
    "One more example of a blog card with random height depending on how much text it has.",

    "Another blog with more content. Flutter makes it super easy to build responsive UIs. Just check this out!",
    "Tiny post,Another blog with more content. Flutter makes it super easy to build responsive UIs. Just check this out!",
    "One more example of a blog card with random height depending on how much text it has.",
  ];

  final List<Color> MoodColors = [
    const Color(0xFF93032E),
    const Color(0xFFFE4A49),
    const Color(0xFFAF5B5B),
    const Color(0xFF52050A),
    const Color(0xFFF03A47),
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
      physics:
          const NeverScrollableScrollPhysics(), // Use if nested inside ScrollView
      itemBuilder: (context, index) {
        final color = MoodColors[index % MoodColors.length];
        return MoodBoardBox(text: blogTexts[index], color: color);
      },
    );
  }
}
