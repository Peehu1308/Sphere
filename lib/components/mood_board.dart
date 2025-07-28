import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MoodBoardBox extends StatelessWidget {
  final String moodimage;
  final Color color;

  const MoodBoardBox({
    super.key,
    required this.color,
    required this.moodimage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        
        child: Image.network(
          moodimage,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.broken_image),
        ),
      ),
    );
  }
}

class MoodGrid extends StatefulWidget {
  const MoodGrid({super.key});

  @override
  State<MoodGrid> createState() => _MoodGridState();
}

class _MoodGridState extends State<MoodGrid> {
  List<String> moodImages = [];

  final List<Color> moodColors = [
    const Color(0xFF93032E),
    const Color(0xFFFE4A49),
    const Color(0xFFAF5B5B),
    const Color(0xFF52050A),
    const Color(0xFFF03A47),
  ];

  @override
  void initState() {
    super.initState();
    fetchMoods();
  }

  Future<void> fetchMoods() async {
    try {
      final response = await Supabase.instance.client
          .from('MoodBoard')
          .select('Image');

      print("Fetched response: $response");

      if (response is List) {
        setState(() {
          moodImages = response
              .where((row) => row['Image'] != null && row['Image'] != "")
              .map<String>((row) => row['Image'] as String)
              .toList();
        });
      }
    } catch (e) {
      print("Error fetching mood images: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return moodImages.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : MasonryGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            itemCount: moodImages.length,
            padding: const EdgeInsets.all(5),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final color = moodColors[index % moodColors.length];
              final img = moodImages[index];
              return MoodBoardBox(moodimage: img, color: color);
            },
          );
  }
}
