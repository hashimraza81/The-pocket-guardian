import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gentech/const/app_colors.dart';
import 'package:gentech/const/app_images.dart';
import 'package:gentech/extension/sizebox_extension.dart';
import 'package:gentech/provider/navigationProvider.dart';
import 'package:gentech/provider/user_choice_provider.dart';
import 'package:gentech/utils/custom_bottom_bar.dart';
import 'package:gentech/utils/custom_text_widget.dart';
import 'package:gentech/view/Tracking/tracking_bottom_bar.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    final userChoice = Provider.of<UserChoiceProvider>(context).userChoice;
    return ChangeNotifierProvider(
      create: (context) => NavigationProvider(),
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
              child: SingleChildScrollView(
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
                        90.0.pw,
                        CustomText(
                          text: 'Notification',
                          size: 24.0.sp,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          familyFont: 'Montserrat',
                        )
                      ],
                    ),
                    40.0.ph,
                    RequestItem(
                      name: 'Brother',
                      actionText: 'is requesting access to',
                      actionItem: 'Accept',
                      imageUrl: AppImages.profile,
                      showButtons: true,
                      color: const Color(0xFFC3E1F3),
                    ),
                    const Divider(
                      color: AppColors.grey4,
                    ),
                    RequestItem(
                      name: 'Sister',
                      actionText: 'is sending request to track you',
                      imageUrl: AppImages.men,
                      showButtons: false,
                    ),
                    const Divider(
                      color: AppColors.grey4,
                    ),
                    RequestItem(
                      name: 'Brother',
                      actionText: 'is requesting access to',
                      actionItem: 'Accept',
                      imageUrl: AppImages.profile,
                      showButtons: false,
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: userChoice == 'Track'
              ? const CustomBottomBar()
              : const TrackingBottomBar(),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class RequestItem extends StatelessWidget {
  final String name;
  final String actionText;
  final String actionItem;
  final String imageUrl;
  final bool showButtons;
  Color? color;

  RequestItem({
    super.key,
    required this.name,
    required this.actionText,
    this.actionItem = '',
    required this.imageUrl,
    this.showButtons = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 8.0.h,
      ),
      child: Container(
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 35.0.r,
                child: ClipOval(
                  child: Image.asset(
                    imageUrl,
                  ),
                ),
              ),
              20.0.pw,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: name,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Montserrat',
                              fontSize: 12.0.sp,
                              color: AppColors.primary,
                            ),
                          ),
                          TextSpan(
                            text: ' $actionText ',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Montserrat',
                              fontSize: 12.0.sp,
                              color: AppColors.primary,
                            ),
                          ),
                          TextSpan(
                            text: actionItem,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Montserrat',
                              fontSize: 12.0.sp,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    5.0.ph,
                    Text(
                      '4h ago • North School, L2 Street',
                      style: TextStyle(
                        color: AppColors.grey3,
                        fontSize: 12.0.sp,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    if (showButtons) ...[
                      10.0.ph,
                      Row(
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all(AppColors.secondary),
                            ),
                            onPressed: () {},
                            child: Text(
                              'Accept',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 12.0.sp,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          10.0.pw,
                          OutlinedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all(AppColors.white),
                            ),
                            onPressed: () {},
                            child: Text(
                              'Decline',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 12.0.sp,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
