import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weather_app/additional_info_item.dart';
import 'package:weather_app/hourly_forecast_item.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/secret.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String city = 'Accra';
      final res = await http.get(Uri.parse(
          'http://api.openweathermap.org/data/2.5/forecast?q=$city&APPID=$APIKEY'));

      final data = jsonDecode(res.body);

      if (data['cod'] != '200') {
        throw 'An unexpected error occured';
      }

      //Print the data
      //data['list'][0]['main']['temp'];
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: const [
          IconButton(
            onPressed: null,
            icon: Icon(
              Icons.refresh,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          print(snapshot);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }

          final data = snapshot.data!;

          final currentWeatherData = data['list'][0];

          //Get current temperature
          final currentTemp = currentWeatherData['main']['temp'];

          //Get current pressure
          final currentPressure = currentWeatherData['main']['pressure'];

          //Get current wind speed
          final currentWind = currentWeatherData['wind']['speed'];

          // Convert Kelvin to Celcius
          final degreeCelcius = (currentTemp - 273.15).ceil();

          final currentSky = currentWeatherData['weather'][0]['main'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //First Child Main Card
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '$degreeCelcius °C',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(
                                currentSky == 'Clouds' || currentSky == 'Rainy'
                                    ? Icons.cloud
                                    : Icons.sunny,
                                size: 68,
                              ),
                              Text(
                                '$currentSky',
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                //Second Child Weather Forecast Card

                const Text(
                  'Weather Forecast',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),

                const SizedBox(
                  height: 10,
                ),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: const [
                      HourlyForecast(
                          time: '09:00', icon: Icons.cloud, temp: '301.1'),
                      HourlyForecast(
                          time: '12:00', icon: Icons.cloud, temp: '201.1'),
                      HourlyForecast(
                          time: '14:00', icon: Icons.cloud, temp: '101.1'),
                      HourlyForecast(
                          time: '16:00', icon: Icons.cloud, temp: '91.1'),
                    ],
                  ),
                ),

                //Third Child Additional Information
                const SizedBox(
                  height: 20,
                ),

                const Text(
                  'Additional Information',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),

                const SizedBox(
                  height: 10,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInfoItem(
                        icon: Icons.water_drop,
                        condition: 'Humidity',
                        temperature: '91'),
                    AdditionalInfoItem(
                        icon: Icons.air,
                        condition: 'Wind Speed',
                        temperature: currentWind.toString()),
                    AdditionalInfoItem(
                        icon: Icons.beach_access,
                        condition: 'Pressure',
                        temperature: currentPressure.toString())
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
