import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class ReusedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  Color? colorbg;
  Color? colortext;
  Color? bordercolor;

  ReusedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.colorbg,
    this.colortext,
    this.bordercolor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: colorbg,
          borderRadius: BorderRadius.circular(128.r),
          border: Border.all(
            width: 1,
            color: bordercolor ?? Colors.transparent,
          )),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(128.r),
          ),
          minimumSize: Size(340.w, 54.h),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16.sp,
            color: colortext,
            fontWeight: FontWeight.w500,
            fontFamily: 'Montserrat',
          ),
        ),
      ),
    );
  }
}
