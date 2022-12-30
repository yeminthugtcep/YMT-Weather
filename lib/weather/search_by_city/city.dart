import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:weather/weather/ob/dart_object_city.dart';

class SearchCity extends StatefulWidget {
  SearchCityState createState() {
    return SearchCityState();
  }
}

class SearchCityState extends State<SearchCity> {
  final cityNameText = TextEditingController();
  final key = GlobalKey<FormState>();
  DartObjectCityPage? dobCity;
  bool isLoading = false;

  getWeatherData(String CityName) async {
    setState(() {
      isLoading = true;
    });
    print(CityName);
    final http.Response response = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$CityName&appid=054f9e27b6656547c97d32344415f618&units=metric"));
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      dobCity = DartObjectCityPage.fromJson(json.decode(response.body));
      setState(() {
        isLoading = false;
      });
    } else {
      print("Error");
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: key,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(children: [
            Positioned.fill(
                child: Container(
              decoration: const BoxDecoration(
                  gradient: RadialGradient(colors: [
                Colors.blue,
                Colors.indigo,
              ])),
            )),
            //back key
            Positioned(
                top: 10,
                left: 10,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_sharp,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )),
            //search city and search icon
            Positioned(
              top: 50,
              right: 0,
              left: 0,
              bottom: 0,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: cityNameText,
                            validator: (value) => value?.isNotEmpty == true
                                ? null
                                : "requried City Name",
                            decoration: const InputDecoration(
                                hintText: "Search by City",
                                hintStyle: TextStyle(color: Colors.white30)),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (key.currentState!.validate()) {
                              getWeatherData(cityNameText.text);
                            }
                          },
                          icon: const Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                  dobCity == null
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Center(
                                child: Text(
                                  dobCity!.name.toString(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Center(
                                child: Text(
                                  "${dobCity!.main!.temp} 'C",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 60,
                                    child: Image.network(
                                      "http://openweathermap.org/img/wn/${dobCity!.weather![0].icon}@2x.png",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Text(
                                    dobCity!.weather![0].main.toString(),
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ],
                              ),
                              ListTile(
                                title: const Text(
                                  "Wind Speed :",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                trailing: Text(
                                    "${dobCity!.wind!.speed.toString()} meter/sec",
                                    style:
                                        const TextStyle(color: Colors.white)),
                              ),

                              // ignore: prefer_const_constructors
                              ListTile(
                                title: const Text(
                                  "Max Temperature :",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                trailing: Text(
                                  "${dobCity!.main!.tempMax.toString()} 'C",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              ListTile(
                                title: const Text(
                                  "Min Temperature :",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                trailing: Text(
                                  "${dobCity!.main!.tempMin.toString()} 'C",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              ListTile(
                                title: const Text(
                                  "Sunrise :",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                trailing: Text(
                                  DateTime.fromMillisecondsSinceEpoch(
                                          (dobCity!.sys!.sunrise!) * 1000)
                                      .toString(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              ListTile(
                                title: const Text(
                                  "Sunset :",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                trailing: Text(
                                  DateTime.fromMillisecondsSinceEpoch(
                                          (dobCity!.sys!.sunset!) * 1000)
                                      .toString(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              ListTile(
                                title: const Text(
                                  "Humidity :",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                trailing: Text(
                                  dobCity!.main!.humidity.toString(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
