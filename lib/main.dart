import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/screens/main_weather/main_weather_screen.dart';
import 'package:weather_app/shared/bloc_observer/bloc_observer.dart';

void main() {
  BlocOverrides.runZoned (() {
    runApp(MyApp());
  },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home:  MainWeatherScreen(),
    );
  }
}



