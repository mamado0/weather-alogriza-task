class HourlyModel{
  String? icon;
  double? temp;
  String? time;
  HourlyModel({required String icon,required double temp,required String time}){
    this.icon = icon;
    this.temp =temp;
    this.time = time;
  }

  HourlyModel.fromJson(Map<String,dynamic>json,String time){
    this.icon = json['condition']['icon'];
    this.temp=json['temp_c'];
    this.time=time;
  }

}