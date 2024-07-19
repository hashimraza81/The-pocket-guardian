import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gentech/const/app_colors.dart';
import 'package:gentech/const/app_images.dart';
import 'package:gentech/extension/sizebox_extension.dart';
import 'package:gentech/utils/custom_text_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class AlertScreen extends StatefulWidget {
  const AlertScreen({super.key});

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    fetchContacts();
  }

  Future<void> fetchContacts() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('trackUsers')
            .doc(user.uid)
            .get();
        if (userDoc.exists) {
          CollectionReference contactsRef =
              userDoc.reference.collection('contacts');
          QuerySnapshot contactsSnapshot = await contactsRef.get();
          setState(() {
            contacts = contactsSnapshot.docs
                .map((doc) => Contact.fromFirestore(doc))
                .toList();
          });
        }
      }
    } catch (e) {
      print('Error fetching contacts: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.red,
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 25.0.h,
                    horizontal: 16.0.w,
                  ),
                  child: InkWell(
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
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                ),
                55.0.ph,
                Center(
                  child: Image.asset(AppImages.alert),
                ),
                20.0.ph,
                Center(
                  child: CustomText(
                    text: 'Alert',
                    size: 36.0.sp,
                    color: AppColors.white,
                    fontWeight: FontWeight.w400,
                    familyFont: 'Montserrat',
                  ),
                ),
                30.0.ph,
                Center(
                  child: CustomText(
                    text: 'An alert has been sent to\n          your contacts',
                    size: 16.0.sp,
                    color: AppColors.white,
                    fontWeight: FontWeight.w500,
                    familyFont: 'Montserrat',
                  ),
                ),
                48.0.ph,
                Center(
                  child: CircleAvatar(
                    backgroundColor: AppColors.white,
                    radius: 60.0.r,
                    child: CustomText(
                      text: "I'm Safe",
                      size: 20.0.sp,
                      color: AppColors.red,
                      fontWeight: FontWeight.w600,
                      familyFont: 'Montserrat',
                    ),
                  ),
                ),
                90.0.ph,
                contacts.isEmpty
                    ? Center(
                        child: CustomText(
                          text: 'No contacts available',
                          size: 16.0.sp,
                          color: AppColors.white,
                          fontWeight: FontWeight.w500,
                          familyFont: 'Montserrat',
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.0.w,
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: contacts.length,
                          itemBuilder: (context, index) {
                            final contact = contacts[index];
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Button(
                                    text: 'Message',
                                    onPressed: () async {
                                      await launchUrl(
                                        Uri(
                                          scheme: 'sms',
                                          path: contact.phoneNumber,
                                        ),
                                      );
                                    },
                                    colorbg: Colors.transparent,
                                    bordercolor: AppColors.white,
                                    colortext: AppColors.white,
                                    image: AppImages.msg,
                                  ),
                                  Button(
                                    text: 'Call',
                                    onPressed: () async {
                                      await launchUrl(
                                        Uri(
                                          scheme: 'tel',
                                          path: contact.phoneNumber,
                                        ),
                                      );
                                    },
                                    colorbg: Colors.transparent,
                                    bordercolor: AppColors.white,
                                    colortext: AppColors.white,
                                    image: AppImages.call,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Button extends StatelessWidget {
  final String text;
  final String image;
  final VoidCallback onPressed;
  final Color? colorbg;
  final Color? colortext;
  final Color? bordercolor;

  const Button({
    super.key,
    required this.text,
    required this.image,
    required this.onPressed,
    this.colorbg,
    this.colortext,
    this.bordercolor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colorbg,
        borderRadius: BorderRadius.circular(128.r),
        border: Border.all(
          width: 1,
          color: bordercolor ?? Colors.transparent,
        ),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(128.r),
          ),
          minimumSize: Size(170.w, 50.h),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(image),
            5.0.pw,
            Text(
              text,
              style: TextStyle(
                fontSize: 16.sp,
                color: colortext,
                fontWeight: FontWeight.w500,
                fontFamily: 'Montserrat',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Contact {
  final String id;
  final String name;
  final String phoneNumber;
  final String imageUrl;

  Contact({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.imageUrl,
  });

  factory Contact.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Contact(
      id: doc.id,
      name: data['name'] ?? '',
      phoneNumber: data['phonenumber'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }
}
