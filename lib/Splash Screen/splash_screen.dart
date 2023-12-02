import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rms_app/auth/auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration(seconds: 4),(){
      Get.off(Auth());
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FadeIn(
          duration: Duration(seconds: 3),
          child: Image(
            image: AssetImage("assets/splash.png"),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
        ),
    );
  }
}