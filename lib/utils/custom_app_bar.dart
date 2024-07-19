import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gentech/const/app_images.dart';
import 'package:gentech/routes/routes_names.dart';

class customAppBar extends StatelessWidget {
  const customAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Icon(
          Icons.menu,
          size: 40.0,
        ),
        Image.asset(
          AppImages.logo,
          height: 40.h,
          width: 125.w,
        ),
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, RoutesName.profile);
          },
          child: CircleAvatar(
            radius: 30.r,
            child: ClipOval(
              child: Image.asset(
                AppImages.profile,
                fit: BoxFit.cover,
                height: 60.h,
                width: 60.w,
              ),
            ),
          ),
        )
      ],
    );
  }
}
