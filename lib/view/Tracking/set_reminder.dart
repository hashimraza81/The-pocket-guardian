import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gentech/const/app_colors.dart';
import 'package:gentech/extension/sizebox_extension.dart';
import 'package:gentech/provider/tracking_bottom_bar_Provider.dart';
import 'package:gentech/utils/custom_text_widget.dart';
import 'package:gentech/view/Tracking/tracking_bottom_bar.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

class SetReminder extends StatefulWidget {
  const SetReminder({super.key});

  @override
  State<SetReminder> createState() => _SetReminderState();
}

class _SetReminderState extends State<SetReminder> {
  var hour = 0;
  var minute = 0;
  var timeFormat = "AM";
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
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w700,
                            familyFont: 'Montserrat',
                          ),
                          20.0.ph,
                          SizedBox(
                            height: 50.0,
                            child: ListView(
                              scrollDirection: Axis
                                  .horizontal, // Allows horizontal scrolling
                              children: [
                                CustomButton(
                                  text: 'No Reminder',
                                  onPressed: () {},
                                  colorbg: AppColors.white,
                                  colortext: AppColors.primary,
                                  bordercolor: AppColors.grey4,
                                  size: 12.0.sp,
                                  radius: 12.0.r,
                                ),
                                CustomButton(
                                  text: 'In An Hour',
                                  onPressed: () {},
                                  colorbg: AppColors.grey6,
                                  colortext: AppColors.primary,
                                  size: 12.0.sp,
                                  radius: 12.0.r,
                                ),
                                CustomButton(
                                  text: 'In Two Hour',
                                  onPressed: () {},
                                  colorbg: AppColors.grey6,
                                  colortext: AppColors.primary,
                                  size: 12.0.sp,
                                  radius: 12.0.r,
                                ),
                              ],
                            ),
                          ),
                          20.0.ph,
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: AppColors.grey6,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 50.0.w,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            timeFormat = "AM";
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          decoration: BoxDecoration(
                                            color: timeFormat == "AM"
                                                ? AppColors.primary
                                                : AppColors.white,
                                            border: Border.all(
                                              color: timeFormat == "AM"
                                                  ? AppColors.white
                                                  : AppColors.primary,
                                            ),
                                          ),
                                          child: Text(
                                            "AM",
                                            style: TextStyle(
                                                color: timeFormat == "AM"
                                                    ? AppColors.white
                                                    : AppColors.primary,
                                                fontSize: 25),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            timeFormat = "PM";
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          decoration: BoxDecoration(
                                            color: timeFormat == "AM"
                                                ? AppColors.white
                                                : AppColors.primary,
                                            border: Border.all(
                                              color: timeFormat == "AM"
                                                  ? AppColors.primary
                                                  : AppColors.white,
                                            ),
                                          ),
                                          child: Text(
                                            "PM",
                                            style: TextStyle(
                                              color: timeFormat == "PM"
                                                  ? AppColors.white
                                                  : AppColors.primary,
                                              fontSize: 25,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  10.0.ph,
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      NumberPicker(
                                        minValue: 0,
                                        maxValue: 12,
                                        value: hour,
                                        zeroPad: true,
                                        infiniteLoop: true,
                                        itemWidth: 80,
                                        itemHeight: 60,
                                        onChanged: (value) {
                                          setState(() {
                                            hour = value;
                                          });
                                        },
                                        textStyle: const TextStyle(
                                            color: AppColors.grey4,
                                            fontSize: 20),
                                        selectedTextStyle: const TextStyle(
                                            color: AppColors.primary,
                                            fontSize: 30),
                                        decoration: const BoxDecoration(
                                          border: Border(
                                              top: BorderSide(
                                                color: Colors.white,
                                              ),
                                              bottom: BorderSide(
                                                  color: Colors.white)),
                                        ),
                                      ),
                                      NumberPicker(
                                        minValue: 0,
                                        maxValue: 59,
                                        value: minute,
                                        zeroPad: true,
                                        infiniteLoop: true,
                                        itemWidth: 80,
                                        itemHeight: 60,
                                        onChanged: (value) {
                                          setState(() {
                                            minute = value;
                                          });
                                        },
                                        textStyle: const TextStyle(
                                            color: AppColors.grey4,
                                            fontSize: 20),
                                        selectedTextStyle: const TextStyle(
                                            color: AppColors.primary,
                                            fontSize: 30),
                                        decoration: const BoxDecoration(
                                          border: Border(
                                              top: BorderSide(
                                                color: Colors.white,
                                              ),
                                              bottom: BorderSide(
                                                  color: Colors.white)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          20.0.ph,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CustomButton(
                                text: 'Cancel',
                                onPressed: () {},
                                colorbg: AppColors.white,
                                colortext: AppColors.secondary,
                                size: 16.0.sp,
                                bordercolor: AppColors.secondary,
                                radius: 128.0.r,
                              ),
                              CustomButton(
                                text: 'Done',
                                onPressed: () {},
                                colorbg: AppColors.secondary,
                                colortext: AppColors.white,
                                size: 16.0.sp,
                                radius: 128.0.r,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
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

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  Color? colorbg;
  Color? colortext;
  Color? bordercolor;
  final double? size;
  final double? radius;

  CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.colorbg,
    this.colortext,
    this.bordercolor,
    this.size,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: colorbg,
            borderRadius: BorderRadius.circular(radius!),
            border: Border.all(
              width: 1,
              color: bordercolor ?? Colors.transparent,
            )),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            // minimumSize: Size(110.w, 32.h),
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(
              fontSize: size,
              color: colortext,
              fontWeight: FontWeight.w500,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
      ),
    );
  }
}
