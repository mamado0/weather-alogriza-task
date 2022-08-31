import 'package:weather_app/models/hourly_model.dart';

class DayWeatherModel{
  String? date;
  double? maxTemp;
  double? minTemp;
  String? status;
  String? sunRise;
  String? sunSet;
  String? moonRise;
  String? moonSet;
  String? moonPhase;
  List<HourlyModel>?hourlist;

  DayWeatherModel({
    String? date,
    double? maxTemp,
    double? minTemp,
    String? status,
    String? sunRise,
    String? sunSet,
    String? moonRise,
    String? moonSet,
    String? moonPhase,
    List<HourlyModel>?hourlist,
  })
  {
    this.date=date;
    this.maxTemp=maxTemp;
    this.minTemp=minTemp;
    this.status=status;
    this.sunRise=sunRise;
    this.sunSet=sunSet;
    this.moonRise=moonRise;
    this.moonSet=moonSet;
    this.moonPhase=moonPhase;
    this.hourlist=hourlist;
  }
}