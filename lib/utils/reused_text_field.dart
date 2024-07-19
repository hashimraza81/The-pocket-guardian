import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gentech/const/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String text;
  final IconData? iconData;
  final bool toHide;
  final void Function(String)? onchanged;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.text,
    this.iconData,
    required this.toHide,
    this.onchanged,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late TextEditingController _controller;
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _obscureText = widget.toHide;
    _controller.addListener(_updateIconColor);
  }

  @override
  void dispose() {
    _controller.removeListener(_updateIconColor);
    super.dispose();
  }

  void _updateIconColor() {
    setState(() {});
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 16.sp,
        color: AppColors.primary,
        fontWeight: FontWeight.w400,
      ),
      controller: _controller,
      onChanged: widget.onchanged,
      obscureText: _obscureText,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.white,
        hintText: widget.text,
        hintStyle: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 16.sp,
          color: AppColors.grey4,
          fontWeight: FontWeight.w400,
        ),
        suffixIcon: widget.toHide
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: _controller.text.isNotEmpty
                      ? AppColors.primary
                      : AppColors.grey4,
                ),
                onPressed: _toggleObscureText,
              )
            : Icon(
                widget.iconData,
                color: _controller.text.isNotEmpty
                    ? AppColors.primary
                    : AppColors.grey4,
              ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.transparent,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.transparent,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}
