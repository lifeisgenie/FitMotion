import 'package:FitMotion/pages/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _loadResources();
  }

  Future<void> _loadResources() async {
    // 비동기 작업 수행 (예: 데이터 로딩, 초기화 등)
    await Future.delayed(Duration(seconds: 3));

    // 비동기 작업 완료 후 홈 화면으로 이동
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => Index()),
    );
  }

  final spinkit = SpinKitFadingCircle(
    color: Colors.blue,
    size: 50.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: spinkit,
      ),
    );
  }
}
