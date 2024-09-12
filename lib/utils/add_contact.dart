// import 'package:contacts_service/contacts_service.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gentech/const/app_colors.dart';
// import 'package:gentech/extension/sizebox_extension.dart';
// import 'package:gentech/provider/add_contact_provider.dart';
// import 'package:gentech/provider/user_choice_provider.dart';
// import 'package:gentech/utils/custom_text_widget.dart';
// import 'package:gentech/utils/reused_button.dart';
// import 'package:gentech/utils/reused_text_field.dart';
// import 'package:provider/provider.dart';

// class AddContact extends StatelessWidget {
//   const AddContact({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider<AddContactProvider>(
//       create: (context) => AddContactProvider()..getContactPermission(),
//       child: Consumer<AddContactProvider>(
//         builder: (context, contactProvider, child) {
//           return SafeArea(
//             child: GestureDetector(
//               onTap: () {
//                 FocusManager.instance.primaryFocus?.unfocus();
//               },
//               child: Scaffold(
//                 backgroundColor: AppColors.sccafold,
//                 appBar: AppBar(
//                   leading: IconButton(
//                     icon: const Icon(Icons.arrow_back_ios),
//                     color: AppColors.primary,
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                   ),
//                   title: CustomText(
//                     text: 'Add',
//                     size: 24.0,
//                     color: AppColors.primary,
//                     fontWeight: FontWeight.w700,
//                     familyFont: 'Montserrat',
//                   ),
//                   centerTitle: true,
//                 ),
//                 body: SingleChildScrollView(
//                   padding: const EdgeInsets.symmetric(
//                       vertical: 10.0, horizontal: 15.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Center(
//                         child: InkWell(
//                           child: CircleAvatar(
//                             backgroundColor: AppColors.secondary,
//                             radius: 60.0.r,
//                             backgroundImage: contactProvider.selectedUser !=
//                                         null &&
//                                     contactProvider.selectedUser!['imageUrl'] !=
//                                         null
//                                 ? NetworkImage(
//                                     contactProvider.selectedUser!['imageUrl'])
//                                 : null,
//                             child: contactProvider.selectedUser == null ||
//                                     contactProvider.selectedUser!['imageUrl'] ==
//                                         null
//                                 ? const Icon(
//                                     Icons.person,
//                                     size: 60,
//                                     color: AppColors.white,
//                                   )
//                                 : null,
//                           ),
//                         ),
//                       ),
//                       5.ph,
//                       Center(
//                         child: CustomText(
//                           text: 'Add New Conatct',
//                           size: 16.0.sp,
//                           color: AppColors.secondary,
//                           fontWeight: FontWeight.w600,
//                           familyFont: 'Montserrat',
//                         ),
//                       ),
//                       10.ph,
//                       const Divider(color: AppColors.grey5),
//                       // TextField(
//                       //   controller: contactProvider.searchController,
//                       //   decoration: InputDecoration(
//                       //     filled: true,
//                       //     fillColor: AppColors.white,
//                       //     border: const OutlineInputBorder(),
//                       //     hintText: "Search Member ",
//                       //     hintStyle: TextStyle(
//                       //       fontFamily: 'Montserrat',
//                       //       fontSize: 16.sp,
//                       //       color: AppColors.grey4,
//                       //       fontWeight: FontWeight.w400,
//                       //     ),
//                       //     prefixIcon: const Icon(
//                       //       Icons.search,
//                       //       color: AppColors.grey4,
//                       //     ),
//                       //     enabledBorder: OutlineInputBorder(
//                       //       borderSide: const BorderSide(
//                       //         color: Colors.transparent,
//                       //         width: 1.0,
//                       //       ),
//                       //       borderRadius: BorderRadius.circular(30),
//                       //     ),
//                       //     focusedBorder: OutlineInputBorder(
//                       //       borderSide: const BorderSide(
//                       //         color: Colors.transparent,
//                       //         width: 2.0,
//                       //       ),
//                       //       borderRadius: BorderRadius.circular(30),
//                       //     ),
//                       //   ),
//                       //   onChanged: (query) {
//                       //     contactProvider.searchFromFirebase(
//                       //         query,
//                       //         Provider.of<UserChoiceProvider>(context,
//                       //                 listen: false)
//                       //             .userChoice);
//                       //   },
//                       // ),

//                       // if (contactProvider.searchResult.isNotEmpty)
//                       //   Padding(
//                       //     padding: const EdgeInsets.all(8.0),
//                       //     child: Container(
//                       //       color: AppColors.white,
//                       //       child: ListView.builder(
//                       //         itemCount: contactProvider.searchResult.length,
//                       //         shrinkWrap: true,
//                       //         itemBuilder: (context, index) {
//                       //           var contact =
//                       //               contactProvider.searchResult[index];
//                       //           return ListTile(
//                       //             leading: CircleAvatar(
//                       //               radius: 30.0.r,
//                       //               backgroundImage: contact['imageUrl'] != null
//                       //                   ? NetworkImage(contact['imageUrl'])
//                       //                   : const AssetImage(
//                       //                           'assets/default_image.png')
//                       //                       as ImageProvider,
//                       //             ),
//                       //             title: Text(contact['name'] ?? 'No name'),
//                       //             subtitle:
//                       //                 Text(contact['email'] ?? 'No email'),
//                       //             onTap: () {
//                       //               contactProvider.selectUser(contact);
//                       //             },
//                       //           );
//                       //         },
//                       //       ),
//                       //     ),
//                       //   ),
//                       TextField(
//                         controller: contactProvider.searchController,
//                         decoration: InputDecoration(
//                           filled: true,
//                           fillColor: AppColors.white,
//                           border: const OutlineInputBorder(),
//                           hintText: "Search Member ",
//                           hintStyle: TextStyle(
//                             fontFamily: 'Montserrat',
//                             fontSize: 16.sp,
//                             color: AppColors.grey4,
//                             fontWeight: FontWeight.w400,
//                           ),
//                           prefixIcon: const Icon(
//                             Icons.search,
//                             color: AppColors.grey4,
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: const BorderSide(
//                               color: Colors.transparent,
//                               width: 1.0,
//                             ),
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: const BorderSide(
//                               color: Colors.transparent,
//                               width: 2.0,
//                             ),
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                         ),
//                         onChanged: (query) {
//                           contactProvider.searchFromFirebase(
//                               query,
//                               Provider.of<UserChoiceProvider>(context,
//                                       listen: false)
//                                   .userChoice);
//                         },
//                         onEditingComplete: () {
//                           FocusManager.instance.primaryFocus
//                               ?.unfocus(); // Close the keyboard
//                         },
//                       ),

// // Only show the list if the search query is not empty
//                       if (contactProvider.searchController.text.isNotEmpty &&
//                           contactProvider.searchResult.isNotEmpty)
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Container(
//                             color: AppColors.white,
//                             child: ListView.builder(
//                               itemCount: contactProvider.searchResult.length,
//                               shrinkWrap: true,
//                               itemBuilder: (context, index) {
//                                 var contact =
//                                     contactProvider.searchResult[index];
//                                 return ListTile(
//                                   leading: CircleAvatar(
//                                     radius: 30.0.r,
//                                     backgroundImage: contact['imageUrl'] != null
//                                         ? NetworkImage(contact['imageUrl'])
//                                         : const AssetImage(
//                                                 'assets/default_image.png')
//                                             as ImageProvider,
//                                   ),
//                                   title: Text(contact['name'] ?? 'No name'),
//                                   subtitle:
//                                       Text(contact['email'] ?? 'No email'),
//                                   onTap: () {
//                                     contactProvider.selectUser(contact);
//                                   },
//                                 );
//                               },
//                             ),
//                           ),
//                         ),

//                       10.ph,
//                       CustomTextField(
//                         controller: contactProvider.nameController,
//                         text: 'Name',
//                         toHide: false,
//                       ),
//                       15.ph,
//                       TextField(
//                         controller: contactProvider.phoneNumberController,
//                         decoration: InputDecoration(
//                           filled: true,
//                           fillColor: AppColors.white,
//                           border: const OutlineInputBorder(),
//                           hintText: "Enter Phone Number",
//                           hintStyle: TextStyle(
//                             fontFamily: 'Montserrat',
//                             fontSize: 16.sp,
//                             color: AppColors.grey4,
//                             fontWeight: FontWeight.w400,
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: const BorderSide(
//                               color: Colors.transparent,
//                               width: 1.0,
//                             ),
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: const BorderSide(
//                               color: Colors.transparent,
//                               width: 2.0,
//                             ),
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                         ),
//                         onChanged: contactProvider.filterContacts,
//                       ),
//                       // 10.ph,
//                       if (contactProvider.filteredContacts.isNotEmpty)
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Container(
//                             color: AppColors.white,
//                             child: ListView.builder(
//                               itemCount:
//                                   contactProvider.filteredContacts.length,
//                               shrinkWrap: true,
//                               itemBuilder: (context, index) {
//                                 Contact contact =
//                                     contactProvider.filteredContacts[index];
//                                 return ListTile(
//                                   title: Text(contact.displayName ?? 'No name'),
//                                   subtitle: Text(contact.phones?.first.value ??
//                                       'No phone'),
//                                   onTap: () {
//                                     contactProvider.selectContact(contact);
//                                   },
//                                 );
//                               },
//                             ),
//                           ),
//                         ),
//                       15.ph,
//                       CustomTextField(
//                         controller: contactProvider.emailController,
//                         text: 'Email',
//                         toHide: false,
//                       ),
//                       24.ph,
//                       ReusedButton(
//                         text: 'Add',
//                         onPressed: () {
//                           contactProvider.addContact(
//                               context,
//                               Provider.of<UserChoiceProvider>(context,
//                                       listen: false)
//                                   .userChoice,
//                               FirebaseAuth.instance.currentUser);
//                         },
//                         colorbg: AppColors.secondary,
//                         colortext: AppColors.white,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:fast_contacts/fast_contacts.dart'; // Replaced contacts_service with fast_contacts
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gentech/const/app_colors.dart';
import 'package:gentech/extension/sizebox_extension.dart';
import 'package:gentech/provider/add_contact_provider.dart';
import 'package:gentech/provider/user_choice_provider.dart';
import 'package:gentech/utils/custom_text_widget.dart';
import 'package:gentech/utils/reused_button.dart';
import 'package:gentech/utils/reused_text_field.dart';
import 'package:provider/provider.dart';

class AddContact extends StatelessWidget {
  const AddContact({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddContactProvider>(
      create: (context) => AddContactProvider()..getContactPermission(),
      child: Consumer<AddContactProvider>(
        builder: (context, contactProvider, child) {
          return SafeArea(
            child: GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Scaffold(
                backgroundColor: AppColors.sccafold,
                appBar: AppBar(
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    color: AppColors.primary,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  title: CustomText(
                    text: 'Add',
                    size: 24.0,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    familyFont: 'Montserrat',
                  ),
                  centerTitle: true,
                ),
                body: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: InkWell(
                          child: CircleAvatar(
                            backgroundColor: AppColors.secondary,
                            radius: 60.0.r,
                            backgroundImage: contactProvider.selectedUser !=
                                        null &&
                                    contactProvider.selectedUser!['imageUrl'] !=
                                        null
                                ? NetworkImage(
                                    contactProvider.selectedUser!['imageUrl'])
                                : null,
                            child: contactProvider.selectedUser == null ||
                                    contactProvider.selectedUser!['imageUrl'] ==
                                        null
                                ? const Icon(
                                    Icons.person,
                                    size: 60,
                                    color: AppColors.white,
                                  )
                                : null,
                          ),
                        ),
                      ),
                      5.ph,
                      Center(
                        child: CustomText(
                          text: 'Add New Conatct',
                          size: 16.0.sp,
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w600,
                          familyFont: 'Montserrat',
                        ),
                      ),
                      10.ph,
                      const Divider(color: AppColors.grey5),

                      TextField(
                        controller: contactProvider.searchController,
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
                          contactProvider.searchFromFirebase(
                              query,
                              Provider.of<UserChoiceProvider>(context,
                                      listen: false)
                                  .userChoice);
                        },
                        onEditingComplete: () {
                          FocusManager.instance.primaryFocus
                              ?.unfocus(); // Close the keyboard
                        },
                      ),

// Only show the list if the search query is not empty
                      if (contactProvider.searchController.text.isNotEmpty &&
                          contactProvider.searchResult.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            color: AppColors.white,
                            child: ListView.builder(
                              itemCount: contactProvider.searchResult.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                var contact =
                                    contactProvider.searchResult[index];
                                return ListTile(
                                  leading: CircleAvatar(
                                    radius: 30.0.r,
                                    backgroundImage: contact['imageUrl'] != null
                                        ? NetworkImage(contact['imageUrl'])
                                        : const AssetImage(
                                                'assets/default_image.png')
                                            as ImageProvider,
                                  ),
                                  title: Text(contact['name'] ?? 'No name'),
                                  subtitle:
                                      Text(contact['email'] ?? 'No email'),
                                  onTap: () {
                                    contactProvider.selectUser(contact);
                                  },
                                );
                              },
                            ),
                          ),
                        ),

                      10.ph,
                      CustomTextField(
                        controller: contactProvider.nameController,
                        text: 'Name',
                        toHide: false,
                      ),
                      15.ph,
                      TextField(
                        controller: contactProvider.phoneNumberController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.white,
                          border: const OutlineInputBorder(),
                          hintText: "Enter Phone Number",
                          hintStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16.sp,
                            color: AppColors.grey4,
                            fontWeight: FontWeight.w400,
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
                        onChanged: contactProvider.filterContacts,
                      ),

                      // Display filtered contacts
                      if (contactProvider.filteredContacts.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            color: AppColors.white,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight:
                                    200.0.h, // Scrollable container height
                              ),
                              child: Scrollbar(
                                // Adding a scrollbar for scrolling
                                child: ListView.builder(
                                  itemCount:
                                      contactProvider.filteredContacts.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    Contact contact =
                                        contactProvider.filteredContacts[index];
                                    return ListTile(
                                      title: Text(
                                          contact.displayName ?? 'No name'),
                                      subtitle: Text(contact.phones.isNotEmpty
                                          ? contact.phones.first.number
                                          : 'No phone'), // Accessing the phone number
                                      onTap: () {
                                        contactProvider.selectContact(contact);
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      15.ph,
                      CustomTextField(
                        controller: contactProvider.emailController,
                        text: 'Email',
                        toHide: false,
                      ),
                      24.ph,
                      ReusedButton(
                        text: 'Add',
                        onPressed: () {
                          contactProvider.addContact(
                              context,
                              Provider.of<UserChoiceProvider>(context,
                                      listen: false)
                                  .userChoice,
                              FirebaseAuth.instance.currentUser);
                        },
                        colorbg: AppColors.secondary,
                        colortext: AppColors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
