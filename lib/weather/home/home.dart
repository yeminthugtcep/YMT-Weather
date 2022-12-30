import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:weather/weather/daily/daily.dart';
import 'dart:convert';

import 'package:weather/weather/ob/dart_object.dart';
import 'package:weather/weather/search_by_city/city.dart';

class WeatherHome extends StatefulWidget {
  WeatherHomeState createState() {
    return WeatherHomeState();
  }
}

class WeatherHomeState extends State<WeatherHome> {
  Location location = new Location();
  late DartObjectPage dob;

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
        "https://api.openweathermap.org/data/2.5/weather?lat=${_locationData.latitude}&lon=${_locationData.longitude}&appid=054f9e27b6656547c97d32344415f618&units=metric"));
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      dob = DartObjectPage.fromJson(json.decode(response.body));
      setState(() {
        isLoading = false;
      });
    } else {
      const Center(child: CircularProgressIndicator());
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.indigo, Colors.blue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Center(
                  child: CircularProgressIndicator(
                color: Colors.white,
              )),
            )
          : SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
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
                    top: 100,
                    left: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dob.name.toString(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            DateFormat("EEEE dd, MMMM").format(DateTime.now()),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18),
                          ),
                        ),
                        Text(
                          DateFormat().add_jm().format(DateTime.now()),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return DailyPage();
                              }));
                            },
                            child: const Text(
                              "5 days forecast",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                      bottom: 80,
                      right: 30,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${dob.main!.temp} 'C",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                height: 40,
                                child: Image.network(
                                  "http://openweathermap.org/img/wn/${dob.weather![0].icon}@2x.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Text(
                                dob.weather![0].main.toString(),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ],
                          )
                        ],
                      )),
                  Positioned(
                    top: 95,
                    right: 20,
                    child: IconButton(
                      icon: const Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 25,
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return SearchCity();
                        }));
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
