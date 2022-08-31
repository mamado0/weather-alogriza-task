import 'package:intl/intl.dart';

String dateTimeFormated(){
  final DateFormat format =DateFormat('yyyy-MM-dd');
  final String formattedDate =  format.format(DateTime.now());
  return formattedDate;
}

String nameOfTheDay(){
  String day = DateFormat("EEEE").format(DateTime.now());
  return day;
}