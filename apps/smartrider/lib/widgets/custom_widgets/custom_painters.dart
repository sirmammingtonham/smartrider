import 'package:flutter/material.dart';

/// Creates our 'lines and circles' on the left hand side of the
/// schedule list for each bus. This particular class is responsible
/// for the first stop.
class FillPainter extends CustomPainter {
  final Color? circleColor;
  final Color? lineColor;
  final bool first;
  final bool last;

  /// WARNING: Default value for overflow may need to be changed based on how
  /// much space the names of the
  final double overflow;

  FillPainter(
      {this.circleColor,
      this.lineColor,
      this.first = false,
      this.last = false,
      this.overflow = 30.0})
      : super();

  /// Controls how the circle and lines are drawn.
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    // cascade notation, look it up it's pretty cool
    final line = Paint()
      ..color = lineColor!
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.fill
      ..strokeWidth = 6;

    if (first) {
      canvas.drawLine(Offset(size.width / 2, size.height + overflow),
          Offset(size.width / 2, size.height / 2 + 15), line);
    } else if (last) {
      canvas.drawLine(Offset(size.width / 2, size.height / 2 - 15.0),
          Offset(size.width / 2, -overflow), line);
    } else {
      canvas.drawLine(Offset(size.width / 2, (size.height / 2) - 15.0),
          Offset(size.width / 2, -overflow), line);
      canvas.drawLine(Offset(size.width / 2, (size.height / 2) + 15.0),
          Offset(size.width / 2, size.height + overflow), line);
    }

    // set the color property of the paint
    paint.color = circleColor!;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 3.0;

    // center of the canvas is (x,y) => (width/2, height/2)
    var center = Offset(size.width / 2, size.height / 2);

    canvas.drawCircle(center, 11.0, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// Creates our 'lines and circles' on the left hand side of the
/// schedule list for each bus. This particular class is responsible
/// for all stops but the first.
class StrokePainter extends CustomPainter {
  final Color? circleColor;
  final Color? lineColor;
  final bool last;
  StrokePainter({
    this.circleColor,
    this.lineColor,
    this.last = false,
  }) : super();

  @override
  void paint(Canvas canvas, Size size) {
    Paint line = Paint()
      ..color = lineColor!
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.fill
      ..strokeWidth = 6;

    if (!last) {
      canvas.drawLine(Offset(38.5, size.height), const Offset(38.5, 0), line);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
