import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gentech/const/app_colors.dart';
import 'package:gentech/extension/sizebox_extension.dart';
import 'package:gentech/provider/navigationProvider.dart';
import 'package:gentech/provider/user_choice_provider.dart';
import 'package:gentech/routes/routes_names.dart';
import 'package:gentech/utils/contact_listview.dart';
import 'package:gentech/utils/custom_bottom_bar.dart';
import 'package:gentech/utils/custom_text_widget.dart';
import 'package:gentech/utils/reused_button.dart';
import 'package:gentech/view/Tracking/tracking_bottom_bar.dart';
import 'package:provider/provider.dart';

class AddNumber extends StatefulWidget {
  const AddNumber({super.key});

  @override
  State<AddNumber> createState() => _AddNumberState();
}

class _AddNumberState extends State<AddNumber> {
  @override
  Widget build(BuildContext context) {
    final userChoice = Provider.of<UserChoiceProvider>(context).userChoice;
    return ChangeNotifierProvider(
      create: (context) => NavigationProvider(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.sccafold,
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 25.0.h,
                horizontal: 15.0.w,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
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
                      85.0.pw,
                      CustomText(
                        text: 'Contact',
                        size: 24.0.sp,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        familyFont: 'Montserrat',
                      )
                    ],
                  ),
                  46.0.ph,
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, RoutesName.addcontact);
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
                            text: 'Max 1 Contacts',
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
                  const Expanded(child: ContactListview()),
                  40.0.ph,
                  Center(
                    child: ReusedButton(
                      text: 'Done',
                      onPressed: () {
                        if (userChoice == 'Track') {
                          Navigator.pushNamed(context, RoutesName.home);
                        } else if (userChoice == 'Tracking') {
                          Navigator.pushNamed(context, RoutesName.hometracking);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Error: userChoice is null.'),
                            ),
                          );
                        }
                      },
                      colorbg: AppColors.secondary,
                      colortext: AppColors.white,
                    ),
                  )
                ],
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
