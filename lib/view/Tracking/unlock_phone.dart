// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gentech/const/app_colors.dart';
// import 'package:gentech/const/app_images.dart';
// import 'package:gentech/extension/sizebox_extension.dart';
// import 'package:gentech/provider/contact_provider.dart';
// import 'package:gentech/provider/tracking_bottom_bar_Provider.dart';
// import 'package:gentech/utils/custom_bottom_bar.dart';
// import 'package:gentech/utils/custom_text_widget.dart';
// import 'package:gentech/utils/reused_button.dart';
// import 'package:gentech/view/Tracking/set_reminder.dart';
// import 'package:provider/provider.dart';

// class UnlockPhone extends StatefulWidget {
//   const UnlockPhone({super.key});

//   @override
//   State<UnlockPhone> createState() => _UnlockPhoneState();
// }

// class _UnlockPhoneState extends State<UnlockPhone> {
//   final Map<String, bool> _selectedContacts = {};

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => TrackingBottomBarProvider(),
//       child: SafeArea(
//         child: Scaffold(
//           appBar: AppBar(
//             backgroundColor: AppColors.sccafold,
//             leading: InkWell(
//               onTap: () {
//                 Navigator.pop(context);
//               },
//               child: const Icon(
//                 Icons.arrow_back_ios,
//                 color: AppColors.primary,
//               ),
//             ),
//             title: CustomText(
//               text: 'Unlock Phone',
//               size: 24,
//               color: AppColors.primary,
//               fontWeight: FontWeight.w700,
//               familyFont: 'Montserrat',
//             ),
//             centerTitle: true,
//           ),
//           backgroundColor: AppColors.sccafold,
//           resizeToAvoidBottomInset: true,
//           body: SizedBox(
//             width: MediaQuery.of(context).size.width,
//             height: MediaQuery.of(context).size.height,
//             child: Padding(
//               padding: EdgeInsets.symmetric(
//                 vertical: 15.0.h,
//                 horizontal: 15.0.w,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                       color: AppColors.white,
//                       borderRadius: BorderRadius.circular(10.0.r),
//                     ),
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(
//                         vertical: 20.0.h,
//                         horizontal: 15.0.w,
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           CustomText(
//                             text: 'Set Reminder',
//                             size: 20.0.sp,
//                             color: AppColors.primary,
//                             fontWeight: FontWeight.w700,
//                             familyFont: 'Montserrat',
//                           ),
//                           8.0.ph,
//                           CustomText(
//                             text: 'Which contact set reminder to set?',
//                             size: 14.0.sp,
//                             color: AppColors.primary,
//                             fontWeight: FontWeight.w600,
//                             familyFont: 'Montserrat',
//                           ),
//                           14.0.ph,
//                           ChangeNotifierProvider(
//                             create: (context) =>
//                                 ContactProvider()..subscribeToContacts(context),
//                             child: Consumer<ContactProvider>(
//                               builder: (context, contactProvider, _) {
//                                 if (contactProvider.isLoading) {
//                                   return const Center(
//                                       child: CircularProgressIndicator());
//                                 }

//                                 // Initialize _selectedContacts with contacts
//                                 for (var contact in contactProvider.contacts) {
//                                   if (!_selectedContacts
//                                       .containsKey(contact.uid)) {
//                                     _selectedContacts[contact.uid] = false;
//                                   }
//                                 }

//                                 return ListView.builder(
//                                   shrinkWrap: true,
//                                   itemCount: contactProvider.contacts.length,
//                                   itemBuilder: (context, index) {
//                                     final contact =
//                                         contactProvider.contacts[index];
//                                     return Column(
//                                       children: [
//                                         Container(
//                                           decoration: BoxDecoration(
//                                             color: AppColors.secondary
//                                                 .withOpacity(0.09),
//                                             borderRadius:
//                                                 BorderRadius.circular(10.0),
//                                           ),
//                                           padding: const EdgeInsets.all(16.0),
//                                           child: Row(
//                                             children: [
//                                               CircleAvatar(
//                                                 backgroundImage: contact
//                                                         .imageUrl.isNotEmpty
//                                                     ? NetworkImage(
//                                                         contact.imageUrl)
//                                                     : const AssetImage(
//                                                             AppImages.profile)
//                                                         as ImageProvider,
//                                                 radius: 20.0,
//                                               ),
//                                               const SizedBox(width: 16.0),
//                                               Column(
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   Text(
//                                                     contact.name,
//                                                     style: const TextStyle(
//                                                       fontSize: 14.0,
//                                                       fontWeight:
//                                                           FontWeight.w700,
//                                                       fontFamily: 'Montserrat',
//                                                       color: AppColors.primary,
//                                                     ),
//                                                   ),
//                                                   Row(
//                                                     children: [
//                                                       const Icon(Icons.phone,
//                                                           size: 16.0,
//                                                           color: AppColors
//                                                               .primary),
//                                                       const SizedBox(
//                                                           width: 8.0),
//                                                       Text(
//                                                         contact.phoneNumber,
//                                                         style: const TextStyle(
//                                                           fontSize: 12.0,
//                                                           fontWeight:
//                                                               FontWeight.w400,
//                                                           fontFamily:
//                                                               'Montserrat',
//                                                           color:
//                                                               AppColors.primary,
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ],
//                                               ),
//                                               const Spacer(),
//                                               Checkbox(
//                                                 value: _selectedContacts[
//                                                         contact.uid] ??
//                                                     false,
//                                                 onChanged: (value) {
//                                                   setState(() {
//                                                     _selectedContacts[
//                                                         contact.uid] = value!;
//                                                   });
//                                                 },
//                                                 activeColor:
//                                                     AppColors.secondary,
//                                                 checkColor: AppColors.white,
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         10.ph,
//                                       ],
//                                     );
//                                   },
//                                 );
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   10.0.ph,
//                   ReusedButton(
//                     text: 'Set Reminder',
//                     onPressed: () {
//                       final contactProvider = context.read<ContactProvider>();
//                       final contactList = contactProvider.contacts;

//                       // Filter contacts based on selection
//                       final selectedContacts = contactList
//                           .where((contact) =>
//                               _selectedContacts[contact.uid] == true)
//                           .map((contact) => contact.uid)
//                           .toList();

//                       if (selectedContacts.isNotEmpty) {
//                         // Navigate to SetReminder screen with selected contacts
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => SetReminder(
//                               selectedContacts: selectedContacts,
//                             ),
//                           ),
//                         );
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             content: Text('Please select at least one contact'),
//                           ),
//                         );
//                       }
//                     },
//                     colorbg: AppColors.secondary,
//                     colortext: AppColors.white,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           bottomNavigationBar: const CustomBottomBar(),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gentech/const/app_colors.dart';
import 'package:gentech/extension/sizebox_extension.dart';
import 'package:gentech/provider/contact_provider.dart';
import 'package:gentech/provider/tracking_bottom_bar_Provider.dart';
import 'package:gentech/utils/custom_bottom_bar.dart';
import 'package:gentech/utils/custom_text_widget.dart';
import 'package:gentech/utils/reused_button.dart';
import 'package:gentech/utils/snackbar.dart';
import 'package:gentech/view/Tracking/set_reminder.dart';
import 'package:provider/provider.dart';

class UnlockPhone extends StatefulWidget {
  const UnlockPhone({super.key});

  @override
  State<UnlockPhone> createState() => _UnlockPhoneState();
}

class _UnlockPhoneState extends State<UnlockPhone> {
  final Map<String, bool> _selectedContacts =
      {}; // Track selected contacts by UID

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TrackingBottomBarProvider(),
      child: SafeArea(
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
              text: 'Unlock Phone',
              size: 24,
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
              familyFont: 'Montserrat',
            ),
            centerTitle: true,
          ),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                              text:
                                  'Please select a contact to set the reminder.',
                              size: 14.0.sp,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              familyFont: 'Montserrat',
                            ),
                            14.0.ph,
                            ChangeNotifierProvider(
                              create: (context) => ContactProvider()
                                ..subscribeToContacts(context),
                              child: Consumer<ContactProvider>(
                                builder: (context, contactProvider, _) {
                                  if (contactProvider.isLoading) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }

                                  return ListView.builder(
                                    primary: true,
                                    physics: const ScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: contactProvider.contacts.length,
                                    itemBuilder: (context, index) {
                                      final contact =
                                          contactProvider.contacts[index];
                                      return Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: AppColors.secondary
                                                  .withOpacity(0.09),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            padding: const EdgeInsets.all(16.0),
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 20.0,
                                                  backgroundImage: contact
                                                          .imageUrl.isNotEmpty
                                                      ? NetworkImage(
                                                          contact.imageUrl)
                                                      : null, // No image if the URL is empty
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  child: contact
                                                          .imageUrl.isEmpty
                                                      ? CircleAvatar(
                                                          radius: 20.r,
                                                          child: const Icon(
                                                            Icons
                                                                .person, // Use the desired icon
                                                            size:
                                                                20.0, // Adjust size to fit the avatar
                                                            color: Colors
                                                                .grey, // Customize the icon color if needed
                                                          ),
                                                        )
                                                      : null, // No icon if the URL is not empty
                                                ),
                                                // CircleAvatar(
                                                //   backgroundImage: contact
                                                //           .imageUrl.isNotEmpty
                                                //       ? NetworkImage(
                                                //           contact.imageUrl)
                                                //       : const AssetImage(
                                                //               AppImages.profile)
                                                //           as ImageProvider,
                                                //   radius: 20.0,
                                                // ),
                                                const SizedBox(width: 16.0),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      contact.name,
                                                      style: const TextStyle(
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontFamily:
                                                            'Montserrat',
                                                        color:
                                                            AppColors.primary,
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Icon(Icons.phone,
                                                            size: 16.0,
                                                            color: AppColors
                                                                .primary),
                                                        const SizedBox(
                                                            width: 8.0),
                                                        Text(
                                                          contact.phoneNumber,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 12.0,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontFamily:
                                                                'Montserrat',
                                                            color: AppColors
                                                                .primary,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const Spacer(),
                                                Checkbox(
                                                  value: _selectedContacts[
                                                          contact.uid] ??
                                                      false,
                                                  onChanged: (value) {
                                                    setState(
                                                      () {
                                                        _selectedContacts[
                                                                contact.uid] =
                                                            value!;
                                                        print(
                                                            _selectedContacts);
                                                      },
                                                    );
                                                  },
                                                  activeColor:
                                                      AppColors.secondary,
                                                  checkColor: AppColors.white,
                                                ),
                                              ],
                                            ),
                                          ),
                                          10.ph,
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    10.0.ph,
                    ReusedButton(
                      text: 'Set Reminder',
                      onPressed: () {
                        final contactProvider = context.read<ContactProvider>();
                        final contactList = contactProvider.contacts;

                        // Print all available contacts for debugging
                        print("All available contacts:");
                        for (var contact in contactList) {
                          print("Contact UID: ${contact.uid}");
                        }

                        // Filter contacts based on selection
                        final selectedContacts = _selectedContacts.entries
                            .where((entry) => entry.value == true)
                            .map((entry) => entry.key)
                            .toList();
                        // final selectedContacts = contactList
                        //     .where((contact) =>
                        //         _selectedContacts[contact.uid] == true)
                        //     .map((contact) => contact.uid)
                        //     .toList();

                        print("Selected Contacts Map: $_selectedContacts");
                        print("UIDs to Navigate With: $selectedContacts");

                        if (selectedContacts.isNotEmpty) {
                          // Check if the number of selected contacts is as expected
                          if (selectedContacts.length !=
                              _selectedContacts.values
                                  .where((selected) => selected)
                                  .length) {
                            print(
                                "Warning: Number of selected UIDs doesn't match expected count.");
                          }
                          // Navigate to SetReminder screen with selected contacts
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SetReminder(
                                selectedContacts: selectedContacts,
                              ),
                            ),
                          );

                          print("Navigating with UIDs: $selectedContacts");
                        } else {
                          showTopSnackBar(
                            context,
                            'Please select at least one contact',
                            Colors.red,
                          );
                        }
                      },
                      colorbg: AppColors.secondary,
                      colortext: AppColors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: const CustomBottomBar(),
        ),
      ),
    );
  }
}
