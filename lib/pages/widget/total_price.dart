import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PriceTag extends StatelessWidget {
  String title, value;
  PriceTag({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 14, color: Colors.black, fontWeight: FontWeight.w700),
          ),
          Text(
            value,
            style: TextStyle(
                fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
