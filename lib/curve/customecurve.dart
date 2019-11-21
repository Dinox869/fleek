import 'package:flutter/material.dart';
import 'package:fleek/theme/color.dart';


class Curvez extends CustomPainter
{
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    Paint paint = Paint();

    path.lineTo(0,size.height *0.99);
    var firstEndPoint = Offset(size.width *.5,size.height -35.0);
    var firstControlPoint = Offset(size.width *.25,size.height -50.0);
    path.quadraticBezierTo(firstControlPoint.dx,firstControlPoint.dy,firstEndPoint.dx,firstEndPoint.dy);


    var secondEndPoint = Offset(size.width,size.height -80.0);
    var secondControlPoint = Offset(size.width *.75,size.height -10.0);
    path.quadraticBezierTo(secondControlPoint.dx,secondControlPoint.dy,secondEndPoint.dx,secondEndPoint.dy);
    path.lineTo(size.width,0);
    paint.color = colorOne;
    canvas.drawPath(path, paint);
    path.close();


  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

}