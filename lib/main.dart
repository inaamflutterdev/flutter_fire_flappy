import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fire_flappy/pages/login.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:sizer/sizer.dart';

Future<void> main() async {
  await Hive.initFlutter();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDExAD_UZRUFof63ny5L-mXmbYVHJjONn8",
      appId: "1:69433083966:android:98789bd52d3a78d078e96f",
      messagingSenderId: "69433083966",
      projectId: "flutter-fire-flappy",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Sizer(
          builder: (context, orientation, deviceType) {
            return MaterialApp(
              builder: (context, child) => ResponsiveWrapper.builder(child,
                  maxWidth: 1200,
                  minWidth: 480,
                  defaultScale: true,
                  breakpoints: [
                    const ResponsiveBreakpoint.resize(400, name: MOBILE),
                    const ResponsiveBreakpoint.autoScale(760, name: TABLET),
                    const ResponsiveBreakpoint.resize(1020, name: DESKTOP),
                    const ResponsiveBreakpoint.autoScale(1440, name: '4K'),
                  ],
                  background: Container(color: const Color(0xFFF5F5F5))),
              debugShowCheckedModeBanner: false,
              title: 'Flutter Firebase Auth',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: const Login(),
            );
          },
        );
      },
    );
  }
}
