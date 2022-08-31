part of 'weather_cubit.dart';

@immutable
abstract class WeatherState {}

class WeatherInitial extends WeatherState {}

class GetWeatherLoadingState extends WeatherState{}

class GetWeatherSuccessfullyState extends WeatherState{}

class GetWeatherErrorState extends WeatherState{}

class InternetConnectedSuccessfully extends WeatherState{}

class InternetConnectedError extends WeatherState{}


