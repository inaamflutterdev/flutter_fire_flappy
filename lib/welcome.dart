import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_fire_flappy/pages/login.dart';

// ignore: camel_case_types
class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => const Login())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: AlignmentDirectional.center,
              child: Column(children: [
                const Text(
                  'Welcome to FlutterFire',
                  style: TextStyle(fontSize: 30),
                  textAlign: TextAlign.center,
                ),
                ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      "assets/images/flutterfire.png",
                      height: 150,
                    )),
              ]),
            ),
          ],
        )),
      ),
    );
  }
}
