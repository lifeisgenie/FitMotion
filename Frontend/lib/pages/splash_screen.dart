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
    _loadResources();
  }

  Future<void> _loadResources() async {
    isLogin = await checkLoginStatus();

    // 2초간 Splash 화면
    await Future.delayed(Duration(seconds: 2));

    // 로그인 상태 확인 후 화면 이동
    if (!isLogin) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Login()),
      );
    } else {
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
    if (token != null) {
      return true;
    }
    return false;
  }
}
