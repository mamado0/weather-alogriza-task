import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/screens/main_weather/cubit/weather_cubit.dart';
import 'package:weather_app/shared/components.dart';

import '../../models/dayWeatherModel.dart';
import '../../models/hourly_model.dart';

class MainWeatherScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      decoration:const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/background.jpg",),
          fit: BoxFit.cover
        )
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: BlocProvider(
            create: (context){
              return WeatherCubit()..checkInternetConnectivity();
              },
            child: BlocConsumer<WeatherCubit, WeatherState>(
              listener: (context, state) {},
              builder: (context, state) {
                int c=-1;
                WeatherCubit cubit = WeatherCubit.getCubit(context);
                List<DayWeatherModel>dayWeatherList = cubit.nextDayList;
                return SafeArea(
                  child: SizedBox.expand(
                      child:
                          cubit.connection=='no'?
                          Icon(Icons.wifi_off_outlined,size: 150,color: Colors.white,):
                      Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: cubit.successfullyGetWeatherFlag==0
                        ? Center(child: CircularProgressIndicator(color: Colors.white,strokeWidth: 5,))
                        : SingleChildScrollView(
                          child: Column(
                            children: [
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 80,
                                    ),
                                    Center(
                                      child: Column(
                                        children: [
                                          Text(
                                            "${cubit.location}",
                                            style: const TextStyle(
                                              fontSize: 45,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            "${cubit.structredWeatherData!.status}",
                                            style: const TextStyle(
                                                fontSize: 20, color: Colors.white),
                                          ),
                                          Text(
                                            "${cubit.structredWeatherData!.cur_deg}°",
                                            style: const TextStyle(
                                                fontSize: 120,

                                                color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 50,
                                    ),
                                    Text(
                                      "${nameOfTheDay()}   Today",
                                      style: const TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      height: 150,
                                      padding: EdgeInsets.all(8.0),
                                      decoration: const BoxDecoration(
                                          border: Border.symmetric(
                                              horizontal:
                                                  BorderSide(color: Colors.white))),
                                      child: ListView.separated(
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder:
                                              (BuildContext context, int index) {
                                            return hourlyWeatherItem(index,cubit.hourList);
                                          },
                                          separatorBuilder:
                                              (BuildContext context, int index) {
                                            return const SizedBox(
                                              width: 20,
                                            );
                                          },
                                          itemCount: cubit.hourList.length),
                                    ),
                                    const SizedBox(height: 50,),
                                    Row(
                                      children: [
                                        Text("SunRise: ${cubit.nextDayList[0].sunRise}",
                                          style: const TextStyle(
                                              fontSize: 20, color: Colors.white),
                                        ),
                                        const Spacer(),
                                        Text("SunSet: ${cubit.nextDayList[0].sunSet}",
                                          style:const TextStyle(
                                              fontSize: 20, color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 50,),
                                    Row(
                                      children: [
                                        Text("MoonRise: ${cubit.nextDayList[0].moonRise}",
                                          style:const TextStyle(
                                              fontSize: 18, color: Colors.white),
                                        ),
                                        Spacer(),
                                        Text("MoonSet: ${cubit.nextDayList[0].moonSet}",
                                          style: TextStyle(
                                              fontSize: 18, color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 50,),
                                    Align(
                                      alignment: AlignmentDirectional.centerStart,
                                      child: Text("Moon Phase: ${cubit.nextDayList[0].moonPhase}",
                                        style:const TextStyle(
                                            fontSize: 20, color: Colors.white),

                                      ),
                                    )
                                  ],
                                ),
                              const SizedBox(height: 130,),
                              Column(
                                children:dayWeatherList.map((element){
                                  c++;
                                  return nextDaysItem(cubit.nextDayList,c);
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                  )
                  ),
                );
              },
            ),
          ),
        ),
    );
  }

  Widget hourlyWeatherItem(int index , List<HourlyModel>hourList) {
    return hourWidgetList(hourList[index].time!,hourList[index].icon!,hourList[index].temp!);
  }

  Widget hourWidgetList(String time,String icon,double temp){
    return Column(
      children: [
        Text(
          "$time",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        SizedBox(
          height: 10,
        ),
        Image.network("https:$icon",
          width: 50,
          height: 50,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "$temp°",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget nextDaysItem(List<DayWeatherModel>data,int index){
    if(index==0)return Container();
    return Column(
      children: [
        Center(
          child: Column(
            children: [
              SizedBox(height: 10,),
              Text("${data[index].date}",
                style: TextStyle(
                  fontSize: 45,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10,),
              Text("${data[index].status}",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10,),
        Row(
          children: [
            Text("Max Temp ${data[index].maxTemp}°",
              style: TextStyle(
                  fontSize: 23, color: Colors.white),
            ),
            Spacer(),
            Text("Min Temp ${data[index].minTemp}°",
              style: TextStyle(
                  fontSize: 23, color: Colors.white),
            ),
          ],
        ),
        SizedBox(height: 100,),
        Container(
          height: 150,
          decoration: BoxDecoration(
            border: Border.symmetric(horizontal: BorderSide(color: Colors.white)),
          ),
          child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder:
                  (BuildContext context, int index1) {
                return hourlyWeatherItem(index1,data[index].hourlist!);
              },
              separatorBuilder:
                  (BuildContext context, int index) {
                return SizedBox(
                  width: 20,
                );
              },
              itemCount: 24
          ),
        ),
        SizedBox(height: 100,),
        Row(
          children: [
            Text("SunRise: ${data[index].sunRise}",
              style: TextStyle(
                  fontSize: 20, color: Colors.white),
            ),
            Spacer(),
            Text("SunSet: ${data[index].sunSet}",
              style: TextStyle(
                  fontSize: 20, color: Colors.white),
            ),
          ],
        ),
        SizedBox(height: 50,),
        Row(
          children: [
            Text("MoonRise: ${data[index].moonSet}",
              style: TextStyle(
                  fontSize: 18, color: Colors.white),
            ),
            Spacer(),
            Text("MoonSet: ${data[index].moonRise}",
              style: TextStyle(
                  fontSize: 18, color: Colors.white),
            ),
          ],
        ),
        SizedBox(height: 50,),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text("Moon Phase: ${data[index].moonPhase}",
            style: TextStyle(
                fontSize: 20, color: Colors.white),

          ),
        ),
        SizedBox(height: 130,),
      ],
    );
  }

}
