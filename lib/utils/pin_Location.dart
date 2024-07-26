import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:gentech/const/app_colors.dart';
import 'package:gentech/provider/places_provider.dart';
import 'package:provider/provider.dart';

class PlacesSearchScreen extends StatefulWidget {
  const PlacesSearchScreen({super.key});

  @override
  _PlacesSearchScreenState createState() => _PlacesSearchScreenState();
}

class _PlacesSearchScreenState extends State<PlacesSearchScreen> {
  final TextEditingController typeAheadController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch the initial location for the user
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final placesProvider =
          Provider.of<LocationPlacesProvider>(context, listen: false);
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        placesProvider.setUserId(user.uid);
        placesProvider.fetchInitialLocation().then((_) {
          typeAheadController.text = placesProvider.selectedLocation ?? '';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final placesProvider = Provider.of<LocationPlacesProvider>(context);

    return Container(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            placesProvider.selectedLocation == null
                ? TypeAheadField(
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: typeAheadController,
                      decoration: InputDecoration(
                        labelText: 'Search Place',
                        labelStyle: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.grey4,
                        ),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    suggestionsCallback: (pattern) async {
                      await placesProvider.fetchSuggestions(pattern);
                      return placesProvider.suggestions;
                    },
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        title: Text(suggestion['description']),
                      );
                    },
                    onSuggestionSelected: (suggestion) {
                      placesProvider.savePlaceDetails(
                          suggestion['place_id'], suggestion['description']);
                      typeAheadController.clear();
                    },
                  )
                : GestureDetector(
                    onTap: () {
                      placesProvider.clearSelectedLocation();
                      typeAheadController.text = '';
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.grey3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              placesProvider.selectedLocation!,
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          const Icon(Icons.edit, color: AppColors.grey3),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
