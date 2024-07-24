import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gentech/const/app_colors.dart';
import 'package:gentech/provider/navigationProvider.dart';
import 'package:gentech/provider/user_choice_provider.dart';
import 'package:gentech/utils/custom_bottom_bar.dart';
import 'package:gentech/utils/custom_text_widget.dart';
import 'package:gentech/view/Tracking/tracking_bottom_bar.dart';
import 'package:gentech/view/Tracking/tracking_location.dart';
import 'package:provider/provider.dart';

// class NotificationScreen extends StatefulWidget {
//   const NotificationScreen({super.key});

//   @override
//   State<NotificationScreen> createState() => _NotificationScreenState();
// }

// class _NotificationScreenState extends State<NotificationScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final userChoice = Provider.of<UserChoiceProvider>(context).userChoice;
//     return ChangeNotifierProvider(
//       create: (context) => NavigationProvider(),
//       child: SafeArea(
//         child: Scaffold(
//           backgroundColor: AppColors.sccafold,
//           resizeToAvoidBottomInset: true,
//           body: SizedBox(
//             width: MediaQuery.of(context).size.width,
//             height: MediaQuery.of(context).size.height,
//             child: Padding(
//               padding: EdgeInsets.symmetric(
//                 vertical: 25.0.h,
//                 horizontal: 15.0.w,
//               ),
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         InkWell(
//                           onTap: () {
//                             Navigator.pop(context);
//                           },
//                           child: Container(
//                             height: 44.0.h,
//                             width: 44.0.w,
//                             decoration: BoxDecoration(
//                               color: AppColors.white,
//                               borderRadius: BorderRadius.circular(
//                                 10.0.r,
//                               ),
//                             ),
//                             child: const Icon(
//                               Icons.arrow_back_ios,
//                               color: AppColors.primary,
//                             ),
//                           ),
//                         ),
//                         90.0.pw,
//                         CustomText(
//                           text: 'Notification',
//                           size: 24.0.sp,
//                           color: AppColors.primary,
//                           fontWeight: FontWeight.w700,
//                           familyFont: 'Montserrat',
//                         )
//                       ],
//                     ),
//                     40.0.ph,
//                     RequestItem(
//                       name: 'Brother',
//                       actionText: 'is requesting access to',
//                       actionItem: 'Accept',
//                       imageUrl: AppImages.profile,
//                       showButtons: true,
//                       color: const Color(0xFFC3E1F3),
//                     ),
//                     const Divider(
//                       color: AppColors.grey4,
//                     ),
//                     RequestItem(
//                       name: 'Sister',
//                       actionText: 'is sending request to track you',
//                       imageUrl: AppImages.men,
//                       showButtons: false,
//                     ),
//                     const Divider(
//                       color: AppColors.grey4,
//                     ),
//                     RequestItem(
//                       name: 'Brother',
//                       actionText: 'is requesting access to',
//                       actionItem: 'Accept',
//                       imageUrl: AppImages.profile,
//                       showButtons: false,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           bottomNavigationBar: userChoice == 'Track'
//               ? const CustomBottomBar()
//               : const TrackingBottomBar(),
//         ),
//       ),
//     );
//   }
// }

// // ignore: must_be_immutable
// class RequestItem extends StatelessWidget {
//   final String name;
//   final String actionText;
//   final String actionItem;
//   final String imageUrl;
//   final bool showButtons;
//   Color? color;

//   RequestItem({
//     super.key,
//     required this.name,
//     required this.actionText,
//     this.actionItem = '',
//     required this.imageUrl,
//     this.showButtons = false,
//     this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(
//         vertical: 8.0.h,
//       ),
//       child: Container(
//         color: color,
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Row(
//             children: [
//               CircleAvatar(
//                 radius: 35.0.r,
//                 child: ClipOval(
//                   child: Image.asset(
//                     imageUrl,
//                   ),
//                 ),
//               ),
//               20.0.pw,
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text.rich(
//                       TextSpan(
//                         children: [
//                           TextSpan(
//                             text: name,
//                             style: TextStyle(
//                               fontWeight: FontWeight.w600,
//                               fontFamily: 'Montserrat',
//                               fontSize: 12.0.sp,
//                               color: AppColors.primary,
//                             ),
//                           ),
//                           TextSpan(
//                             text: ' $actionText ',
//                             style: TextStyle(
//                               fontWeight: FontWeight.w400,
//                               fontFamily: 'Montserrat',
//                               fontSize: 12.0.sp,
//                               color: AppColors.primary,
//                             ),
//                           ),
//                           TextSpan(
//                             text: actionItem,
//                             style: TextStyle(
//                               fontWeight: FontWeight.w600,
//                               fontFamily: 'Montserrat',
//                               fontSize: 12.0.sp,
//                               color: AppColors.primary,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     5.0.ph,
//                     Text(
//                       '4h ago • North School, L2 Street',
//                       style: TextStyle(
//                         color: AppColors.grey3,
//                         fontSize: 12.0.sp,
//                         fontFamily: 'Montserrat',
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                     if (showButtons) ...[
//                       10.0.ph,
//                       Row(
//                         children: [
//                           ElevatedButton(
//                             style: ButtonStyle(
//                               backgroundColor:
//                                   WidgetStateProperty.all(AppColors.secondary),
//                             ),
//                             onPressed: () {},
//                             child: Text(
//                               'Accept',
//                               style: TextStyle(
//                                 color: AppColors.white,
//                                 fontSize: 12.0.sp,
//                                 fontFamily: 'Montserrat',
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                           10.0.pw,
//                           OutlinedButton(
//                             style: ButtonStyle(
//                               backgroundColor:
//                                   WidgetStateProperty.all(AppColors.white),
//                             ),
//                             onPressed: () {},
//                             child: Text(
//                               'Decline',
//                               style: TextStyle(
//                                 color: AppColors.primary,
//                                 fontSize: 12.0.sp,
//                                 fontFamily: 'Montserrat',
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
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
              padding: const EdgeInsets.symmetric(
                vertical: 25.0,
                horizontal: 15.0,
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
                          height: 44.0,
                          width: 44.0,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 90.0),
                      CustomText(
                        text: 'Notification',
                        size: 24.0,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        familyFont: 'Montserrat',
                      )
                    ],
                  ),
                  const SizedBox(height: 40.0),
                  currentUser == null
                      ? const Center(child: Text("No user data available"))
                      : Expanded(
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('pushNotifications')
                                .where('receiverId', isEqualTo: currentUser.uid)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              final notifications = snapshot.data!.docs;
                              return ListView.builder(
                                itemCount: notifications.length,
                                itemBuilder: (context, index) {
                                  final notification = notifications[index];
                                  return FutureBuilder<DocumentSnapshot>(
                                    future: FirebaseFirestore.instance
                                        .collection('trackUsers')
                                        .doc(notification['senderId'])
                                        .get(),
                                    builder: (context, senderSnapshot) {
                                      if (!senderSnapshot.hasData) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      }
                                      if (!senderSnapshot.data!.exists) {
                                        // Handle the case where the sender document does not exist
                                        return const Center(
                                            child:
                                                Text("Sender data not found"));
                                      }
                                      final sender = senderSnapshot.data!;
                                      final name = sender.get('name') ??
                                          'Unknown Sender';
                                      final imageUrl =
                                          sender.get('imageUrl') as String?;

                                      // Debugging prints
                                      print('Sender Data: ${sender.data()}');
                                      print('Sender Name: $name');
                                      print('Sender Image URL: $imageUrl');

                                      return RequestItem(
                                        name: name,
                                        actionText: notification['title'],
                                        actionItem: 'Accept',
                                        imageUrl: imageUrl,
                                        showButtons: true,
                                        color: const Color(0xFFC3E1F3),
                                        onAccept: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  TrackingLocation(
                                                lat: notification[
                                                    'senderlocation']['lat'],
                                                lng: notification[
                                                    'senderlocation']['lng'],
                                                imageUrl: sender.get('imageUrl')
                                                    as String?,
                                                phonenumber:
                                                    sender.get('phonenumber'),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
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
          bottomNavigationBar: userChoice == 'Track'
              ? const CustomBottomBar()
              : const TrackingBottomBar(),
        ),
      ),
    );
  }
}

// Modified RequestItem to include onAccept callback
class RequestItem extends StatelessWidget {
  final String name;
  final String actionText;
  final String actionItem;
  final String? imageUrl;
  final bool showButtons;
  final Color? color;
  final VoidCallback? onAccept;

  const RequestItem({
    super.key,
    required this.name,
    required this.actionText,
    this.actionItem = '',
    this.imageUrl,
    this.showButtons = false,
    this.color,
    this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 35.0,
                child: ClipOval(
                  child: imageUrl != null
                      ? Image.network(imageUrl!)
                      : const Icon(Icons.person, size: 35.0),
                ),
              ),
              const SizedBox(width: 20.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Montserrat',
                              fontSize: 12.0,
                              color: AppColors.primary,
                            ),
                          ),
                          TextSpan(
                            text: ' $actionText ',
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Montserrat',
                              fontSize: 12.0,
                              color: AppColors.primary,
                            ),
                          ),
                          TextSpan(
                            text: actionItem,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Montserrat',
                              fontSize: 12.0,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    const Text(
                      '4h ago • North School, L2 Street',
                      style: TextStyle(
                        color: AppColors.grey3,
                        fontSize: 12.0,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    if (showButtons) ...[
                      const SizedBox(height: 10.0),
                      Row(
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all(AppColors.secondary),
                            ),
                            onPressed: onAccept,
                            child: const Text(
                              'Accept',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 12.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          OutlinedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all(AppColors.white),
                            ),
                            onPressed: () {},
                            child: const Text(
                              'Decline',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 12.0,
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
