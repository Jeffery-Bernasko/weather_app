import 'package:flutter/material.dart';

class HourlyForecast extends StatelessWidget {
  final String temp;
  final IconData icon;
  final String time;
  const HourlyForecast(
      {super.key, required this.time, required this.icon, required this.temp});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                time,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Icon(icon),
              Text(temp)
            ],
          ),
        ),
      ),
    );
  }
}
