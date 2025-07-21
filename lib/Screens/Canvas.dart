import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';

void main() => runApp(MyDrawingApp());

class MyDrawingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DrawingHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

enum DrawMode { rectangle, circle, free }

class PositionedImage {
  ui.Image image;
  Offset position;

  PositionedImage({required this.image, required this.position});
}

class DrawingHomePage extends StatefulWidget {
  @override
  _DrawingHomePageState createState() => _DrawingHomePageState();
}

class _DrawingHomePageState extends State<DrawingHomePage> {
  List<PositionedImage> images = [];
  Offset? selectedImageOffset;
  int? selectedImageIndex;

  List<DrawnShape> shapes = [];
  List<DrawnLine> lines = [];
  DrawMode currentMode = DrawMode.rectangle;
  Color selectedColor = Colors.black;
  Offset? startPoint;

  @override
  void initState() {
    super.initState();
    loadImage('assets/album.jpg');
  }

  Future<void> loadImage(String assetPath) async {
    final data = await rootBundle.load(assetPath);
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    setState(() {
      images.add(PositionedImage(image: frame.image, position: Offset(100, 100)));
    });
  }

  void clearCanvas() {
    setState(() {
      shapes.clear();
      lines.clear();
      images.clear();
    });
  }

  void undo() {
    setState(() {
      if (lines.isNotEmpty) {
        lines.removeLast();
      } else if (shapes.isNotEmpty) {
        shapes.removeLast();
      } else if (images.isNotEmpty) {
        images.removeLast();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sketch Board'),
        actions: [
          IconButton(icon: const Icon(Icons.undo), onPressed: undo),
          IconButton(icon: const Icon(Icons.clear), onPressed: clearCanvas),
        ],
      ),
      body: GestureDetector(
        onPanStart: (details) {
          final box = context.findRenderObject() as RenderBox;
          final localPosition = box.globalToLocal(details.globalPosition);

          for (int i = images.length - 1; i >= 0; i--) {
            final img = images[i];
            final imgRect = Rect.fromLTWH(
              img.position.dx,
              img.position.dy,
              img.image.width.toDouble(),
              img.image.height.toDouble(),
            );

            if (imgRect.contains(localPosition)) {
              selectedImageIndex = i;
              selectedImageOffset = localPosition - img.position;
              return;
            }
          }

          if (currentMode == DrawMode.free) {
            setState(() {
              lines.add(DrawnLine(points: [localPosition], color: selectedColor));
            });
          } else {
            startPoint = localPosition;
          }
        },
        onPanUpdate: (details) {
          final box = context.findRenderObject() as RenderBox;
          final localPosition = box.globalToLocal(details.globalPosition);

          if (selectedImageIndex != null) {
            setState(() {
              images[selectedImageIndex!] = PositionedImage(
                image: images[selectedImageIndex!].image,
                position: localPosition - selectedImageOffset!,
              );
            });
          } else if (currentMode == DrawMode.free) {
            setState(() {
              lines.last.points.add(localPosition);
            });
          } else {
            setState(() {
              if (startPoint != null) {
                if (shapes.isNotEmpty && shapes.last.mode == currentMode) {
                  shapes.removeLast();
                }
                shapes.add(DrawnShape(
                  start: startPoint!,
                  end: localPosition,
                  color: selectedColor,
                  mode: currentMode,
                ));
              }
            });
          }
        },
        onPanEnd: (_) {
          selectedImageIndex = null;
          selectedImageOffset = null;
        },
        child: CustomPaint(
          painter: SketchPainter(shapes: shapes, lines: lines, images: images),
          child: Container(),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildModeButton(Icons.crop_square, DrawMode.rectangle),
              _buildModeButton(Icons.circle, DrawMode.circle),
              _buildModeButton(Icons.brush, DrawMode.free),
              _buildColorPicker(Colors.red),
              _buildColorPicker(Colors.green),
              _buildColorPicker(Colors.blue),
              _buildColorPicker(Colors.black),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeButton(IconData icon, DrawMode mode) {
    return IconButton(
      icon: Icon(
        icon,
        color: currentMode == mode ? Colors.amber : Colors.grey,
      ),
      onPressed: () => setState(() => currentMode = mode),
    );
  }

  Widget _buildColorPicker(Color color) {
    return GestureDetector(
      onTap: () => setState(() => selectedColor = color),
      child: CircleAvatar(
        backgroundColor: color,
        radius: 12,
        child: selectedColor == color ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
      ),
    );
  }
}

class DrawnShape {
  final Offset start;
  final Offset end;
  final Color color;
  final DrawMode mode;

  DrawnShape({required this.start, required this.end, required this.color, required this.mode});
}

class DrawnLine {
  List<Offset> points;
  Color color;

  DrawnLine({required this.points, required this.color});
}

class SketchPainter extends CustomPainter {
  final List<DrawnShape> shapes;
  final List<DrawnLine> lines;
  final List<PositionedImage> images;

  SketchPainter({required this.shapes, required this.lines, required this.images});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (var shape in shapes) {
      paint.color = shape.color;
      switch (shape.mode) {
        case DrawMode.rectangle:
          canvas.drawRect(Rect.fromPoints(shape.start, shape.end), paint);
          break;
        case DrawMode.circle:
          final radius = (shape.start - shape.end).distance / 2;
          final center = Offset(
            (shape.start.dx + shape.end.dx) / 2,
            (shape.start.dy + shape.end.dy) / 2,
          );
          canvas.drawCircle(center, radius, paint);
          break;
        default:
          break;
      }
    }

    for (var line in lines) {
      paint.color = line.color;
      for (int i = 0; i < line.points.length - 1; i++) {
        canvas.drawLine(line.points[i], line.points[i + 1], paint);
      }
    }

    for (var img in images) {
      canvas.drawImage(img.image, img.position, Paint());
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
