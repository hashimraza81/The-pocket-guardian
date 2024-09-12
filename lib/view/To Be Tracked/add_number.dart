import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gentech/const/app_colors.dart';
import 'package:gentech/extension/sizebox_extension.dart';
import 'package:gentech/provider/subscription_provider.dart';
import 'package:gentech/provider/user_choice_provider.dart';
import 'package:gentech/utils/contact_listview.dart';
import 'package:gentech/utils/custom_bottom_bar.dart';
import 'package:gentech/utils/custom_text_widget.dart';
import 'package:gentech/view/Tracking/tracking_bottom_bar.dart';
import 'package:provider/provider.dart';

class AddNumber extends StatefulWidget {
  const AddNumber({super.key});

  @override
  State<AddNumber> createState() => _AddNumberState();
}

class _AddNumberState extends State<AddNumber> {
  @override
  void initState() {
    super.initState();
    // Fetch subscription status when the screen initializes
    Provider.of<SubscriptionProvider>(context, listen: false)
        .checkSubscriptionStatus();
  }

  @override
  Widget build(BuildContext context) {
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context);
    final userChoice = Provider.of<UserChoiceProvider>(context).userChoice;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.sccafold,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.primary,
            ),
          ),
          title: CustomText(
            text: 'Contact',
            size: 24.0.sp,
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
            familyFont: 'Montserrat',
          ),
          centerTitle: true,
        ),
        backgroundColor: AppColors.sccafold,
        body: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 25.0.h,
            horizontal: 15.0.w,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        subscriptionProvider.canAddContact(context);
                      },
                      child: CircleAvatar(
                        backgroundColor: AppColors.secondary,
                        radius: 30.0.r,
                        child: const Icon(
                          Icons.add,
                          size: 45,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    14.0.pw,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: 'Add New',
                          size: 16.0.sp,
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w600,
                          familyFont: 'Montserrat',
                        ),
                        3.0.ph,
                        CustomText(
                          text: subscriptionProvider.isSubscribed
                              ? 'Max 8 Contacts'
                              : 'Max 1 Contact',
                          size: 14.0.sp,
                          color: AppColors.grey3,
                          fontWeight: FontWeight.w400,
                          familyFont: 'Montserrat',
                        ),
                      ],
                    )
                  ],
                ),
                18.0.ph,
                const Divider(
                  color: AppColors.grey5,
                ),
                const ContactListview(),
                // 40.0.ph,
                // Center(
                //   child: ReusedButton(
                //     text: 'Done',
                //     onPressed: () {
                //       if (userChoice == 'Track') {
                //         Navigator.pushNamed(context, RoutesName.home);
                //       } else if (userChoice == 'Tracking') {
                //         Navigator.pushNamed(context, RoutesName.hometracking);
                //       } else {
                //         ScaffoldMessenger.of(context).showSnackBar(
                //           const SnackBar(
                //             content: Text('Error: userChoice is null.'),
                //           ),
                //         );
                //       }
                //     },
                //     colorbg: AppColors.secondary,
                //     colortext: AppColors.white,
                //   ),
                // )
              ],
            ),
          ),
        ),
        bottomNavigationBar: userChoice == 'Track'
            ? const CustomBottomBar()
            : const TrackingBottomBar(),
      ),
    );
  }
}
