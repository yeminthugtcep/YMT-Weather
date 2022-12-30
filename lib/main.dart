import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather/weather/home/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "YMT Weather",
    home: WeatherHome(),
  ));
}
