import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gentech/const/app_colors.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class PhoneNumberField extends StatefulWidget {
  final TextEditingController controller;

  const PhoneNumberField({
    super.key,
    required this.controller,
  });

  @override
  _PhoneNumberFieldState createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState extends State<PhoneNumberField> {
  final FocusNode _focusNode = FocusNode();
  Color _textColor = AppColors.grey4;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
    widget.controller.addListener(_handleTextChange);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleTextChange);
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      if (_focusNode.hasFocus) {
        _textColor = AppColors.primary;
      } else if (widget.controller.text.isEmpty) {
        _textColor = AppColors.grey4;
      }
    });
  }

  void _handleTextChange() {
    setState(() {
      if (widget.controller.text.isNotEmpty) {
        _textColor = AppColors.primary;
      } else if (!_focusNode.hasFocus) {
        _textColor = AppColors.grey4;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      // controller: widget.controller,
      focusNode: _focusNode,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.r),
          borderSide: const BorderSide(color: AppColors.grey4),
        ),
        hintText: '9 429 8522',
        hintStyle: TextStyle(
          color: AppColors.grey4,
          fontSize: 16.sp,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w400,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.r),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.r),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.r),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.r),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        suffixIcon: Icon(
          Icons.phone_callback_outlined,
          color: widget.controller.text.isNotEmpty
              ? AppColors.primary
              : AppColors.grey4,
        ),
      ),
      style: TextStyle(color: _textColor),
      dropdownTextStyle: TextStyle(
        fontSize: 16.sp,
        color: AppColors.grey4,
      ),
      initialCountryCode: 'GB',
      onChanged: (phone) {
        widget.controller.text = phone.completeNumber;
      },
    );
  }
}
