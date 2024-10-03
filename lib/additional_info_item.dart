import 'package:flutter/material.dart';

class AdditionalInfoItem extends StatelessWidget {
  final IconData icon;
  final String condition;
  final String temperature;

  const AdditionalInfoItem({
    super.key,
    required this.icon,
    required this.condition,
    required this.temperature,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(
          icon,
          size: 32,
        ),
        Text(condition),
        Text(
          temperature,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
