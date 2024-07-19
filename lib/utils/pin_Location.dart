import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class PinLocation extends StatefulWidget {
  const PinLocation({super.key});

  @override
  State<PinLocation> createState() => _PinLocationState();
}

class _PinLocationState extends State<PinLocation> {
  final TextEditingController _controller = TextEditingController();
  var uuid = const Uuid();
  final String _sessionToken = '123456';
  List<dynamic> _placesLists = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.addListener(() {
      onChanged();
    });
  }

  void onChanged() {
    getSuggestion(_controller.text);
  }

  void getSuggestion(String input) async {
    String kplacesApiKey = 'AIzaSyD_CSB5fEb6ad5uRMs1qpmCV6MAgKgN5cE';
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$kplacesApiKey&sessiontoken=$_sessionToken';

    var response = await http.get(Uri.parse(request));
    var data = response.body.toString();

    if (response.statusCode == 200) {
      setState(() {
        _placesLists = jsonDecode(response.body.toString())['predictions'];
      });
    } else {
      throw Exception('Failed to Load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: _controller,
          decoration: const InputDecoration(
            hintText: 'Search The Place As Home',
          ),
        ),
        SizedBox(
          height: 20,
          child: Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _placesLists.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_placesLists[index]['Description']),
                );
              },
            ),
          ),
        )
      ],
    );
  }
}
