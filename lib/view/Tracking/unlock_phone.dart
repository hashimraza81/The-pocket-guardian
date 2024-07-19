import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gentech/const/app_colors.dart';
import 'package:gentech/const/app_images.dart';
import 'package:gentech/extension/sizebox_extension.dart';
import 'package:gentech/provider/tracking_bottom_bar_Provider.dart';
import 'package:gentech/routes/routes_names.dart';
import 'package:gentech/utils/custom_text_widget.dart';
import 'package:gentech/view/Tracking/tracking_bottom_bar.dart';
import 'package:provider/provider.dart';

class UnlockPhone extends StatefulWidget {
  const UnlockPhone({super.key});

  @override
  State<UnlockPhone> createState() => _UnlockPhoneState();
}

class _UnlockPhoneState extends State<UnlockPhone> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TrackingBottomBarProvider(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.sccafold,
          resizeToAvoidBottomInset: true,
          body: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 25.0.h,
                horizontal: 15.0.w,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 44.0.h,
                          width: 44.0.w,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(
                              10.0.r,
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      46.0.pw,
                      CustomText(
                        text: 'Unlock Phone',
                        size: 24.0.sp,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        familyFont: 'Montserrat',
                      )
                    ],
                  ),
                  30.0.ph,
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10.0.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 20.0.h,
                        horizontal: 15.0.w,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: 'Set Reminder',
                            size: 20.0.sp,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            familyFont: 'Montserrat',
                          ),
                          8.0.ph,
                          CustomText(
                            text: 'Which contact set reminder to set?',
                            size: 14.0.sp,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            familyFont: 'Montserrat',
                          ),
                          14.0.ph,
                          const ContactItem(
                            name: 'Brother',
                            phoneNumber: '(704) 555-0127',
                            imagePath: AppImages.profile,
                          ),
                          10.0.ph,
                          const ContactItem(
                            name: 'Sister',
                            phoneNumber: '(704) 555-0127',
                            imagePath: AppImages.sister,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          bottomNavigationBar: const TrackingBottomBar(),
        ),
      ),
    );
  }
}

class ContactItem extends StatefulWidget {
  final String name;
  final String phoneNumber;
  final String imagePath;

  const ContactItem({
    super.key,
    required this.name,
    required this.phoneNumber,
    required this.imagePath,
  });

  @override
  _ContactItemState createState() => _ContactItemState();
}

class _ContactItemState extends State<ContactItem> {
  bool isChecked = false;

  void _onCheckboxChanged(bool? value) {
    if (value == null) return;

    setState(() {
      isChecked = value;
    });

    if (isChecked) {
      // Delay for 3 seconds and then navigate
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushNamed(context, RoutesName.setreminder);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.secondary.withOpacity(0.09),
        borderRadius: BorderRadius.circular(10.0.r),
      ),
      padding: EdgeInsets.symmetric(
        vertical: 16.0.h,
        horizontal: 16.0.w,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(widget.imagePath),
              radius: 20.0.r,
            ),
            16.0.pw,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: TextStyle(
                    fontSize: 14.0.sp,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Montserrat',
                    color: AppColors.primary,
                  ),
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      AppImages.phone,
                      height: 9.0.r,
                      width: 9.0.r,
                    ),
                    5.0.pw,
                    Text(
                      widget.phoneNumber,
                      style: TextStyle(
                        fontSize: 9.0.sp,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Montserrat',
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            CircleAvatar(
              radius: 10.0,
              backgroundColor: AppColors.white,
              child: Transform.scale(
                scale: 0.8,
                child: Checkbox(
                  value: isChecked,
                  onChanged: _onCheckboxChanged,
                  activeColor: AppColors.secondary,
                  checkColor: AppColors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
