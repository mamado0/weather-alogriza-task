import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:weather_app/models/dayWeatherModel.dart';
import 'package:weather_app/models/hourly_model.dart';
import 'package:weather_app/models/current_weather_model.dart';
import 'package:weather_app/shared/components.dart';

part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit() : super(WeatherInitial());


  double time = 0.00;
  String? timePrecesion;
  CurrentWeatherModel? structredWeatherData;
  String connection = "connected";
  int successfullyGetWeatherFlag = 0;
  String? location;

  Map<String, dynamic>allData = {};

  List<DayWeatherModel>nextDayList = [];
  List<HourlyModel>hourList = [];

  static WeatherCubit getCubit(context) => BlocProvider.of(context);

  Future<dynamic> getWeatherDetails() async {
    print(location);
    String url = "http://api.weatherapi.com/v1/forecast.json?key=22e2434024e549c2aa0231656221502&q=$location&days=3&aqi=no&alerts=no";
    emit(GetWeatherLoadingState());

    nextDayList = [];
    hourList = [];
    time = 0.0;
    get(Uri.parse(url)).then((value) {
      allData = jsonDecode(value.body);
      structredWeatherData = CurrentWeatherModel.fromJson(allData);

      for (var element in allData['forecast']['forecastday']) {
        if (element['date'] != dateTimeFormated()) {
          break;
        }
        for (var elementHour in element['hour']) {
          time++;
          timePrecesion = time.toStringAsFixed(2);
          hourList.add(HourlyModel.fromJson(elementHour, timePrecesion!));
        }
      }

      _structureDataForTheNextDay(allData: allData);

      successfullyGetWeatherFlag = 1;
      emit(GetWeatherSuccessfullyState());
    }).catchError((error) {
      emit(GetWeatherErrorState());
      print("Error in get weather ${error.toString()}");
    });
  }

  void _structureDataForTheNextDay({required Map<String, dynamic>allData}) {
    for (var element in allData['forecast']['forecastday']) {
      List<HourlyModel>hourlist = [];
      double time = 0.0;
      String? timePrecesion;
      for (var elementHour in element['hour']) {
        time++;
        timePrecesion = time.toStringAsFixed(2);
        hourlist.add(HourlyModel.fromJson(elementHour, timePrecesion));
      }
      nextDayList.add(DayWeatherModel(
        date: element['date'],
        hourlist: hourlist,
        maxTemp: element['day']['maxtemp_c'],
        minTemp: element['day']['mintemp_c'],
        moonPhase: element['astro']['moon_phase'],
        moonRise: element['astro']['moonrise'],
        moonSet: element['astro']['moonset'],
        sunRise: element['astro']['sunrise'],
        sunSet: element['astro']['sunset'],
        status: element['day']['condition']['text'],
      ));
    }
  }

  void checkInternetConnectivity() async {
    Connectivity().onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.none) {
        connection = "no";
        successfullyGetWeatherFlag = 0;
        emit(InternetConnectedError());
      }
      else {
        connection = "connection";
        emit(InternetConnectedSuccessfully());
        getCurrentLocation();
      }
    });
  }


  Future getCurrentLocation() async {

    await Geolocator.requestPermission().then((value)async {
      await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
          .then((Position position) {
        print(position);
        getTheCity(position.latitude, position.longitude);
        //print(position.latitude);
      }).catchError((e) {
        SystemNavigator.pop();
        print(e);
      });
    });

  }

  void getTheCity(double latitude,double longitude)async{
     await placemarkFromCoordinates(latitude, longitude).then((value) {
       location=value[0].subAdministrativeArea.toString();
      getWeatherDetails();
    });

  }





}
