import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomText extends StatelessWidget {
  CustomText(
      {required this.text,
      this.size,
      this.familyFont = "Montserrat",
      this.fontWeight = FontWeight.bold,
      this.alignment,
      this.fontStyle,
      this.height,
      this.color = Colors.black,
      super.key});
  final String text;
  double? size;
  String? familyFont;
  FontWeight? fontWeight;
  TextAlign? alignment;
  double? height;
  FontStyle? fontStyle;
  Color? color;
  int? maxLines;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: alignment,
      maxLines: maxLines,
      style: TextStyle(
        fontSize: size,
        height: height,
        fontFamily: familyFont,
        fontStyle: fontStyle,
        color: color,
        fontWeight: fontWeight,
      ),
    );
  }
}
