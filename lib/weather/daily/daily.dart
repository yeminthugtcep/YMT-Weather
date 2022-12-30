import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:location/location.dart';

class DailyPage extends StatefulWidget {
  @override
  State<DailyPage> createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> {
  Location location = new Location();
  //late DartObjectPage dob;

  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
  }

  getLocation() async {
    setState(() {
      isLoading = true;
    });
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    print(_locationData.latitude);
    print(_locationData.longitude);

    final http.Response response = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/forecast?lat=${_locationData.latitude}&lon=${_locationData.longitude}&exclude=hourly,minutely,monthly&appid=054f9e27b6656547c97d32344415f618"));
    // "https://api.openweathermap.org/data/2.5/weather?lat=${_locationData.latitude}&lon=${_locationData.longitude}&exclude=hourly,minutely,monthly&appid=054f9e27b6656547c97d32344415f618&units=metric"
    print(response.statusCode);
    log(response.body);
    if (response.statusCode == 200) {
      // dob = DartObjectPage.fromJson(json.decode(response.body));
      // setState(() {
      //   isLoading = false;
      // });
    } else {
      const Center(child: CircularProgressIndicator());
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.indigo, Colors.blue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          Positioned(
              top: 10,
              left: 10,
              child: TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_back_sharp,
                    color: Colors.white,
                    size: 30,
                  ),
                  label: const Text(
                    "5 days forecast",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  )))
        ]),
      ),
    );
  }
}
