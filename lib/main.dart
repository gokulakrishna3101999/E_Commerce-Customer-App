import 'package:flutter/material.dart';
import 'package:animated_splash/animated_splash.dart';
import 'signIn.dart';

void main() =>runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp
    (
     debugShowCheckedModeBanner: false,
     theme: new ThemeData
     (
       primarySwatch: Colors.pink,
     ),  
     home: AnimatedSplash(
              imagePath: 'images/logo.png',
              home: SignIn(),
              duration: 2000,
              type: AnimatedSplashType.StaticDuration,
            ),
    );
  }
}

