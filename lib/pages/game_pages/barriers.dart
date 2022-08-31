import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Barriers extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  double size;

  // ignore: use_key_in_widget_constructors
  Barriers({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: size,
      decoration: BoxDecoration(
        color: Colors.green,
        border: Border.all(width: 5, color: Colors.black),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
