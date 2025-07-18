import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
        // color: Colors.grey
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

class BlogGrid extends StatefulWidget {
  const BlogGrid({super.key});

  @override
  State<StatefulWidget> createState() => _BlogGridState();
}

class _BlogGridState extends State<BlogGrid> {
  List<String> blogTexts = [];

  final List<Color> blogColors = [
    const Color(0xFF183059),
    const Color(0xFF235A9C),
    const Color(0xFF276FBF),
    const Color(0xFF2F394D),
    const Color(0xFF0A2463),
  ];

  @override
  void initState() {
    fetchBlog();
  }

  Future<void> fetchBlog() async {
    try {
      final response = await Supabase.instance.client
          .from('Blog')
          .select('Blog,Type');

      // print("Fetched the blog: $response");

      if (response is List) {
        setState(() {
          blogTexts = response
              .where((row) => row['Blog'] != null)
              .map<String>((row) => row['Blog'] as String)
              .toList();
        });
      }
    } catch (e) {
      print("Error fetching blog: $e");
    }
  }

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
