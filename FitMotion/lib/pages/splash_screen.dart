import 'package:FitMotion/pages/exercise_detail.dart';
import 'package:FitMotion/pages/index.dart';
import 'package:FitMotion/pages/login.dart';
import 'package:FitMotion/pages/record_screen.dart';
import 'package:flutter/material.dart';

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
    // 비동기 작업 수행 (예: 데이터 로딩, 초기화 등)
    await Future.delayed(Duration(seconds: 3));

    // 비동기 작업 완료 후 홈 화면으로 이동
    if (!isLogin) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Index()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Login()),
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
}
