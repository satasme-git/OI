import 'package:flutter/material.dart';

class CustomPin extends CustomPainter {

  CustomPin();

  void _drawText({
    required Canvas canvas,
    required Size size,
    required String text,
    required double width,
    double? dx,
    double? dy,
    String? fontFamily,
    double fontSize = 22,
    Color color = Colors.black,
    FontWeight? fontWeight,
  }) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontFamily: fontFamily,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 2,
    );

   

  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Colors.grey;

    final rRect = RRect.fromLTRBR(
      30,
      0,
      25,
      100,
      const Radius.circular(0),
    );

    canvas.drawRRect(rRect, paint);

    paint.color = Colors.black;

    final miniRect = RRect.fromLTRBAndCorners(
      0,
      0,
      57,
      57,
      topLeft: const Radius.circular(30),
      bottomLeft: const Radius.circular(30),
      topRight: const Radius.circular(30),
      bottomRight : const Radius.circular(30),
    );

    canvas.drawRRect(miniRect, paint);

    _drawText(
      canvas: canvas,
      size: size,
      text: "",
      dx: size.height + 10,
      width: size.width - size.height - 10,
    );

    
     
    
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
