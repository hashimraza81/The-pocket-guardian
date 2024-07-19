import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gentech/const/app_colors.dart';
import 'package:gentech/const/app_images.dart';
import 'package:gentech/extension/sizebox_extension.dart';
import 'package:gentech/utils/custom_text_widget.dart';

class uploadProfile extends StatelessWidget {
  const uploadProfile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360.w,
      height: 100.h,
      decoration: BoxDecoration(
        color: const Color(0xFFDDECFA),
        border: Border.all(
          width: 1,
          color: const Color(0xff8989894d).withOpacity(0.3),
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        children: [
          SvgPicture.asset(
            AppImages.upload,
          ),
          2.ph,
          CustomText(
            text: 'Upload Photo',
            size: 14.sp,
            familyFont: 'Poppins',
            fontWeight: FontWeight.w400,
            color: const Color(0xff333b4e99).withOpacity(0.6),
          ),
          2.ph,
          CustomText(
            text: '(Max. File size: 25 MB)',
            size: 14.sp,
            familyFont: 'Poppins',
            fontWeight: FontWeight.w400,
            color: AppColors.grey4,
          ),
        ],
      ),
    );
  }
}
