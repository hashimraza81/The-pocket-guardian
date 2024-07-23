import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gentech/const/app_colors.dart';
import 'package:gentech/extension/sizebox_extension.dart';
import 'package:gentech/provider/user_choice_provider.dart';
import 'package:gentech/utils/custom_text_widget.dart';
import 'package:gentech/utils/reused_button.dart';
import 'package:gentech/utils/reused_text_field.dart';
import 'package:provider/provider.dart';

class AddContact extends StatefulWidget {
  const AddContact({super.key});

  @override
  _AddContactState createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  List searchResult = [];
  Map<String, dynamic>? selectedUser;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  void searchFromFirebase(String query, String userRole) async {
    String collectionToSearch =
        userRole == 'Track' ? 'trackingUsers' : 'trackUsers';

    final result = await FirebaseFirestore.instance
        .collection(collectionToSearch)
        .where('name', isEqualTo: query)
        .get();

    setState(() {
      searchResult = result.docs.map((e) {
        var data = e.data();
        data['uid'] = e.id; // Storing the document ID as 'uid'
        return data;
      }).toList();
    });
  }

  void selectUser(Map<String, dynamic> user) {
    setState(() {
      selectedUser = user;
      nameController.text = user['name'] ?? '';
      phoneNumberController.text = user['phonenumber'] ?? '';
      emailController.text = user['email'] ?? '';
      searchResult = [];
    });
  }

  Future<void> addContact() async {
    if (selectedUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Please select a user to add.'),
        ),
      );
      return;
    }

    try {
      String userRole =
          Provider.of<UserChoiceProvider>(context, listen: false).userChoice;
      User? loggedInUser = FirebaseAuth.instance.currentUser;

      if (loggedInUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('No user is currently logged in.'),
          ),
        );
        return;
      }

      String collectionToSaveIn =
          userRole == 'Track' ? 'trackUsers' : 'trackingUsers';

      String selectedUserRole = selectedUser!['role'];
      String selectedUserCollection =
          selectedUserRole == 'Track' ? 'trackUsers' : 'trackingUsers';

      String newDocId = FirebaseFirestore.instance
          .collection(collectionToSaveIn)
          .doc(loggedInUser.uid)
          .collection('contacts')
          .doc()
          .id;

      await FirebaseFirestore.instance
          .collection(collectionToSaveIn)
          .doc(loggedInUser.uid)
          .collection('contacts')
          .doc(newDocId)
          .set({
        'name': nameController.text,
        'phonenumber': phoneNumberController.text,
        'email': emailController.text,
        'uid': selectedUser!['uid'],
        'reference': FirebaseFirestore.instance
            .collection(selectedUserCollection)
            .doc(selectedUser!['uid'])
            .path,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Contact added successfully!'),
        ),
      );
    } catch (error) {
      print('Error adding contact: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Failed to add contact: $error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserChoiceProvider>(
      builder: (context, userChoiceProvider, child) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: AppColors.sccafold,
            body: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(vertical: 25.0, horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        color: AppColors.primary,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(width: 110.0),
                      CustomText(
                        text: 'Add',
                        size: 24.0,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        familyFont: 'Montserrat',
                      ),
                    ],
                  ),
                  const SizedBox(height: 57.0),
                  Row(
                    children: [
                      InkWell(
                        child: CircleAvatar(
                          backgroundColor: AppColors.secondary,
                          radius: 30.0.r,
                          backgroundImage: selectedUser != null &&
                                  selectedUser!['imageUrl'] != null
                              ? NetworkImage(selectedUser!['imageUrl'])
                              : null,
                          child: selectedUser == null ||
                                  selectedUser!['imageUrl'] == null
                              ? const Icon(
                                  Icons.add,
                                  size: 45,
                                  color: AppColors.white,
                                )
                              : null,
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
                  18.ph,
                  const Divider(color: AppColors.grey5),
                  TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.white,
                      border: const OutlineInputBorder(),
                      hintText: "Search Member ",
                      hintStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 16.sp,
                        color: AppColors.grey4,
                        fontWeight: FontWeight.w400,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.grey4,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onChanged: (query) {
                      searchFromFirebase(query, userChoiceProvider.userChoice);
                    },
                  ),
                  10.ph,
                  if (searchResult.isNotEmpty)
                    Container(
                      color: AppColors.white,
                      child: ListView.builder(
                        itemCount: searchResult.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var contact = searchResult[index];
                          return ListTile(
                            leading: CircleAvatar(
                              radius: 30.0.r,
                              backgroundImage: contact['imageUrl'] != null
                                  ? NetworkImage(contact['imageUrl'])
                                  : const AssetImage('assets/default_image.png')
                                      as ImageProvider,
                            ),
                            title: Text(contact['name'] ?? 'No name'),
                            subtitle: Text(contact['email'] ?? 'No email'),
                            onTap: () {
                              selectUser(contact);
                            },
                          );
                        },
                      ),
                    ),
                  24.ph,
                  CustomTextField(
                    controller: nameController,
                    text: 'Name',
                    toHide: false,
                  ),
                  24.ph,
                  CustomTextField(
                    controller: phoneNumberController,
                    text: 'Phone Number',
                    toHide: false,
                  ),
                  24.ph,
                  CustomTextField(
                    controller: emailController,
                    text: 'Email',
                    toHide: false,
                  ),
                  24.ph,
                  ReusedButton(
                    text: 'Add',
                    onPressed: () {
                      // Add functionality to save the contact to the appropriate collection
                      addContact();
                    },
                    colorbg: AppColors.secondary,
                    colortext: AppColors.white,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
