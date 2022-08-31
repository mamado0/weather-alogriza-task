class CurrentWeatherModel {
  String? city;
  double? cur_deg;
  String? status;

  CurrentWeatherModel({required String city,required double cur_deg,required String status}){
    this.city=city;
    this.cur_deg=cur_deg;
    this.status=status;
  }

  CurrentWeatherModel.fromJson(Map<String,dynamic>json){
    this.city = json['location']['name'];
    this.cur_deg=json['current']['temp_c'];
    this.status=json['current']['condition']['text'];
  }
}