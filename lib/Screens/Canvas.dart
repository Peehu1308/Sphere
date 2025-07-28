import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:sphere/components/navbar.dart';

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

enum DrawMode { rectangle, circle, free, select }

class PositionedImage {
  ui.Image image;
  Offset position;
  double scale;

  PositionedImage({
    required this.image,
    required this.position,
    this.scale = 1.0,
  });

  PositionedImage copyWith({Offset? position, double? scale}) {
    return PositionedImage(
      image: image,
      position: position ?? this.position,
      scale: scale ?? this.scale,
    );
  }
}

class DrawingHomePage extends StatefulWidget {
  @override
  _DrawingHomePageState createState() => _DrawingHomePageState();
}

class _DrawingHomePageState extends State<DrawingHomePage> {
  final ImagePicker _picker = ImagePicker();

  List<PositionedImage> images = [];
  int? selectedImageIndex;
  Offset? selectedImageOffset;
  double initialScale = 1.0;

  List<DrawnShape> shapes = [];
  List<DrawnLine> lines = [];
  DrawMode currentMode = DrawMode.rectangle;
  Color selectedColor = Colors.black;
  Offset? startPoint;

  Future<void> pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    final file = File(picked.path);
    final bytes = await file.readAsBytes();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    final image = frame.image;

    setState(() {
      images.add(
        PositionedImage(
          image: image,
          position: const Offset(50, 50),
          scale: 1.0,
        ),
      );
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
      // backgroundColor: const Color.fromARGB(255, 249, 237, 209),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Sketch Board'),
        actions: [
          IconButton(icon: const Icon(Icons.image), onPressed: pickImage),
          IconButton(icon: const Icon(Icons.undo), onPressed: undo),
          IconButton(icon: const Icon(Icons.cleaning_services_rounded), onPressed: clearCanvas),
        ],
      ),
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return GestureDetector(
                onScaleStart: (details) {
                  final box = context.findRenderObject() as RenderBox;
                  final localPosition = box.globalToLocal(details.focalPoint);

                  if (currentMode == DrawMode.select) {
                    for (int i = images.length - 1; i >= 0; i--) {
                      final img = images[i];
                      final rect = Rect.fromLTWH(
                        img.position.dx,
                        img.position.dy,
                        img.image.width * img.scale,
                        img.image.height * img.scale,
                      );
                      if (rect.contains(localPosition)) {
                        selectedImageIndex = i;
                        selectedImageOffset = localPosition - img.position;
                        initialScale = img.scale;
                        break;
                      }
                    }
                  } else if (currentMode == DrawMode.free) {
                    setState(() {
                      lines.add(
                        DrawnLine(points: [localPosition], color: selectedColor),
                      );
                    });
                  } else {
                    startPoint = localPosition;
                  }
                },
                onScaleUpdate: (details) {
                  final box = context.findRenderObject() as RenderBox;
                  final localPosition = box.globalToLocal(details.focalPoint);

                  if (currentMode == DrawMode.select &&
                      selectedImageIndex != null &&
                      selectedImageOffset != null) {
                    setState(() {
                      images[selectedImageIndex!] = images[selectedImageIndex!]
                          .copyWith(
                            position: localPosition - selectedImageOffset!,
                            scale: initialScale * details.scale,
                          );
                    });
                  } else if (currentMode == DrawMode.free) {
                    setState(() {
                      lines.last.points.add(localPosition);
                    });
                  } else if (startPoint != null) {
                    setState(() {
                      if (shapes.isNotEmpty && shapes.last.mode == currentMode) {
                        shapes.removeLast();
                      }
                      shapes.add(
                        DrawnShape(
                          start: startPoint!,
                          end: localPosition,
                          color: selectedColor,
                          mode: currentMode,
                        ),
                      );
                    });
                  }
                },
                onScaleEnd: (_) {
                  selectedImageIndex = null;
                  selectedImageOffset = null;
                  initialScale = 1.0;
                  startPoint = null;
                },
                child: CustomPaint(
                  painter: SketchPainter(
                    shapes: shapes,
                    lines: lines,
                    images: images,
                  ),
                  child: Container(),
                ),
              );
            },
          ),
          Positioned(
            bottom: 150,
            left: 16,
            // right: 16,
            
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildModeButton(Icons.crop_square, DrawMode.rectangle),
                    _buildModeButton(Icons.circle, DrawMode.circle),
                    _buildModeButton(Icons.brush, DrawMode.free),
                    _buildModeButton(Icons.arrow_forward, DrawMode.select),
                    const SizedBox(width: 12),
                    _buildColorPicker(Colors.red),
                    SizedBox(height: 5,),
                    _buildColorPicker(Colors.green),
                    SizedBox(height: 5,),
                    _buildColorPicker(Colors.blue),
                    SizedBox(height: 5,),
                    _buildColorPicker(Colors.black),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Navbar(currentIndex: 3, onTap: (index){}, token: "12"),
    );
  }

  Widget _buildModeButton(IconData icon, DrawMode mode) {
    return IconButton(
      icon: Icon(icon, color: currentMode == mode ? Colors.amber : Colors.black),
      onPressed: () => setState(() => currentMode = mode),
    );
  }

  Widget _buildColorPicker(Color color) {
    return GestureDetector(
      onTap: () => setState(() => selectedColor = color),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: CircleAvatar(
          backgroundColor: color,
          radius: 12,
          child: selectedColor == color
              ? const Icon(Icons.check, size: 16, color: Colors.white)
              : null,
        ),
      ),
    );
  }
}

class DrawnShape {
  final Offset start, end;
  final Color color;
  final DrawMode mode;

  DrawnShape({
    required this.start,
    required this.end,
    required this.color,
    required this.mode,
  });
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

  SketchPainter({
    required this.shapes,
    required this.lines,
    required this.images,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (var shape in shapes) {
      paint.color = shape.color;
      if (shape.mode == DrawMode.rectangle) {
        canvas.drawRect(Rect.fromPoints(shape.start, shape.end), paint);
      } else if (shape.mode == DrawMode.circle) {
        final center = (shape.start + shape.end) / 2;
        final radius = (shape.start - shape.end).distance / 2;
        canvas.drawCircle(center, radius, paint);
      }
    }

    for (var line in lines) {
      paint.color = line.color;
      for (int i = 0; i < line.points.length - 1; i++) {
        canvas.drawLine(line.points[i], line.points[i + 1], paint);
      }
    }

    for (var img in images) {
      final dst = Rect.fromLTWH(
        img.position.dx,
        img.position.dy,
        img.image.width * img.scale,
        img.image.height * img.scale,
      );
      final src = Rect.fromLTWH(
        0,
        0,
        img.image.width.toDouble(),
        img.image.height.toDouble(),
      );
      canvas.drawImageRect(img.image, src, dst, Paint());
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
