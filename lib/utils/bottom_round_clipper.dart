import 'package:flutter/material.dart';

class BottomRoundClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0,
        size.height - 50); // Adjust the height to where the curve should start

    var controlPoint = Offset(size.width / 2, size.height + 50);
    var endPoint = Offset(size.width, size.height - 50);

    path.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);
    path.lineTo(size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
