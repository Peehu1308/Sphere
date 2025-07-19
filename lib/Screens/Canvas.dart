import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

enum DrawMode { free, rectangle, circle }

class DrawingScreen extends StatefulWidget {
  const DrawingScreen({super.key});

  @override
  State<DrawingScreen> createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  List<DrawnShape> shapes = [];
  Color selectedColor = Colors.teal;
  DrawMode currentMode = DrawMode.free;
  Offset? startPoint;
  Offset? endPoint;

  void clearCanvas() => setState(() => shapes.clear());
  void undo() => setState(() => shapes.isNotEmpty ? shapes.removeLast() : null);

  void pickColor() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Pick a color"),
        content: SingleChildScrollView(
          child: BlockPicker(
            pickerColor: selectedColor,
            onColorChanged: (color) => setState(() => selectedColor = color),
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Done"))],
      ),
    );
  }

  void onPanStart(DragStartDetails details) {
    setState(() => startPoint = details.localPosition);
  }

  void onPanUpdate(DragUpdateDetails details) {
    setState(() => endPoint = details.localPosition);
  }

  void onPanEnd(DragEndDetails details) {
    if (startPoint == null || endPoint == null) return;

    final shape = DrawnShape(
      start: startPoint!,
      end: endPoint!,
      color: selectedColor,
      mode: currentMode,
    );

    setState(() {
      shapes.add(shape);
      startPoint = endPoint = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Draw Something')),
      body: Stack(
        children: [
          GestureDetector(
            onPanStart: currentMode == DrawMode.free ? null : onPanStart,
            onPanUpdate: currentMode == DrawMode.free ? null : onPanUpdate,
            onPanEnd: currentMode == DrawMode.free ? null : onPanEnd,
            child: CustomPaint(
              painter: SketchPainter(shapes, selectedColor),
              size: Size.infinite,
            ),
          ),
          if (currentMode == DrawMode.free)
            GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  final point = DrawnShape(
                    start: details.localPosition,
                    end: details.localPosition,
                    color: selectedColor,
                    mode: DrawMode.free,
                  );
                  shapes.add(point);
                });
              },
            ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Card(
        color: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(icon: const Icon(Icons.undo), onPressed: undo),
              IconButton(icon: const Icon(Icons.color_lens), onPressed: pickColor),
              IconButton(
                icon: Icon(Icons.edit, color: currentMode == DrawMode.free ? Colors.blue : null),
                onPressed: () => setState(() => currentMode = DrawMode.free),
              ),
              IconButton(
                icon: Icon(Icons.circle, color: currentMode == DrawMode.circle ? Colors.blue : null),
                onPressed: () => setState(() => currentMode = DrawMode.circle),
              ),
              IconButton(
                icon: Icon(Icons.rectangle, color: currentMode == DrawMode.rectangle ? Colors.blue : null),
                onPressed: () => setState(() => currentMode = DrawMode.rectangle),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DrawnShape {
  final Offset start;
  final Offset end;
  final Color color;
  final DrawMode mode;

  DrawnShape({
    required this.start,
    required this.end,
    required this.color,
    required this.mode,
  });
}

class SketchPainter extends CustomPainter {
  final List<DrawnShape> shapes;
  final Color currentColor;

  SketchPainter(this.shapes, this.currentColor);

  @override
  void paint(Canvas canvas, Size size) {
    for (var shape in shapes) {
      final paint = Paint()
        ..color = shape.color
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      switch (shape.mode) {
        case DrawMode.free:
          canvas.drawCircle(shape.start, 2, paint);
          break;
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
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
