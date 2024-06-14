import 'dart:io';

import 'package:FitMotion/pages/feedback.dart';
import 'package:FitMotion/pages/index.dart';
import 'package:FitMotion/pages/login.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  bool isLogin = false;

  @override
  void initState() {
    super.initState();
    // _clear_pref();
    _loadResources();
  }

  // Future<void> _clear_pref() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.clear();
  // }

  Future<void> _loadResources() async {
    isLogin = await checkLoginStatus();
    // 비동기 작업 수행 (예: 데이터 로딩, 초기화 등)
    await Future.delayed(Duration(seconds: 2));

    File file = File('assets/videos/good.mp4');

    // 비동기 작업 완료 후 홈 화면으로 이동
    if (!isLogin) {
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //       builder: (context) => MyFeedback(
      //             videoFile: file,
      //           )),
      // );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Index()),
      );
    } else {
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //       builder: (context) => MyFeedback(
      //             videoFile: file,
      //           )),
      // );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Index()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Text(
          'FitMotion',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future<bool> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');
    String? email = prefs.getString('email');
    print("token : $token");
    print("email : $email");
    if (token != null) {
      return true;
    }
    return false;
  }
}
