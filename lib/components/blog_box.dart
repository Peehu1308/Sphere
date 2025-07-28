import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sphere/Screens/BlogData.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BlogItem {
  final String text;
  final String imageUrl;

  BlogItem(this.text, this.imageUrl);
}

class BlogBox extends StatelessWidget {
  final String text;
  final Color color;
  final String imageUrl;

  const BlogBox({
    super.key,
    required this.text,
    required this.color,
    required this.imageUrl,
  });

  /// Fix malformed image URLs (e.g., double slashes from Supabase)
  String sanitizeUrl(String url) {
    return url.replaceFirstMapped(
      RegExp(r'^(https?:\/\/)(.*)'),
      (match) => '${match[1]}${match[2]!.replaceAll(RegExp(r'\/+'), '/')}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final fixedUrl = sanitizeUrl(imageUrl);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlogData(
              text: text,
              image: Image.network(
                fixedUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image),
              ),
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left:15.0,right:15,top: 5),
        child: Container(
          // height: 400,
          margin: const EdgeInsets.only(left: 4.0,right:4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: color,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ClipRRect(
                    
                    borderRadius:BorderRadiusGeometry.circular(15),
                    child: Image.network(
                      fixedUrl,
                      fit: BoxFit.cover,
                      // height: 60,
                      // width: 60,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image),
                    ),
                  ),
                  Text(text, maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BlogGrid extends StatefulWidget {
  const BlogGrid({super.key});

  @override
  State<BlogGrid> createState() => _BlogGridState();
}

class _BlogGridState extends State<BlogGrid> {
  List<BlogItem> blogs = [];

  final List<Color> blogColors = [
    const Color(0xFF183059),
    const Color(0xFF235A9C),
    const Color(0xFF276FBF),
    const Color(0xFF2F394D),
    const Color(0xFF0A2463),
  ];

  @override
  void initState() {
    super.initState();
    fetchBlogs();
  }

  String fixImageUrl(String url) {
    return url.replaceFirstMapped(
      RegExp(r'^(https?:\/\/)(.*)'),
      (match) => '${match[1]}${match[2]!.replaceAll(RegExp(r'\/+'), '/')}',
    );
  }

  Future<void> fetchBlogs() async {
    try {
      final response = await Supabase.instance.client
          .from('Blog')
          .select('Blog,Image_blog');

      if (response is List) {
        setState(() {
          blogs = response
              .where((row) => row['Blog'] != null && row['Image_blog'] != null)
              .map<BlogItem>(
                (row) => BlogItem(
                  row['Blog'] as String,
                  fixImageUrl(row['Image_blog'] as String),
                ),
              )
              .toList();
        });
      }
    } catch (e) {
      print("Error fetching blogs: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (blogs.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return MasonryGridView.count(
      crossAxisCount: 1,
      mainAxisSpacing: 7,
      crossAxisSpacing: 4,
      itemCount: blogs.length,
      padding: const EdgeInsets.only(left:8,right:8),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final blog = blogs[index];
        // final color = blogColors[index % blogColors.length];
        final color = const Color.fromARGB(238, 227, 226, 226);
        return BlogBox(text: blog.text, color: color, imageUrl: blog.imageUrl);
      },
    );
  }
}
