import 'dart:async';
import 'package:flutter/material.dart';
import 'loginscreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() { 
    super.initState();
    Timer(
      Duration(seconds: 5),
      ()=> Navigator.pushReplacement(
        context, MaterialPageRoute(
          builder: (content) => LoginScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff2171cc),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            Container(
              margin: EdgeInsets.all(70),
              child: Image.asset('assets/images/foodtrack.png', scale: 2),
            ),
          ],
        ), 
      ),
    );
  }
}
