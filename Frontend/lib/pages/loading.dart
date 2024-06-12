import 'dart:async';
import 'package:FitMotion/pages/feedback_detail.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  List<String> imageUrls = [
    'https://via.placeholder.com/300.png/09f/fff', // Example image URLs
    'https://via.placeholder.com/300.png/021/fff',
    'https://via.placeholder.com/300.png/321/fff',
    'https://via.placeholder.com/300.png/654/fff',
    'https://via.placeholder.com/300.png/987/fff'
  ];
  List<String> tips = [
    '운동 전에는 반드시 스트레칭을 하세요!',
    '물을 충분히 마셔주세요.',
    '정확한 자세로 운동하는 것이 중요합니다.',
    '규칙적으로 운동하는 습관을 가지세요.'
  ];
  int currentTipIndex = 0;
  int _progress = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _progress = (timer.tick * 100 / 20).toInt();
        currentTipIndex = (currentTipIndex + 1) % tips.length;
      });

      if (timer.tick >= 20) {
        timer.cancel();
        // 로딩 완료 후 다른 페이지로 이동
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  FeedbackPage(fd_id: 1)), // 여기에 적절한 fd_id 값 전달
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'FitMotion',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 300,
              height: 200,
              color: Colors.white,
              child: Image.network(
                imageUrls[_progress % imageUrls.length],
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'AI 분석중입니다...',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            LinearProgressIndicator(
              value: _progress / 100,
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
              minHeight: 10,
            ),
            SizedBox(height: 10),
            Text(
              '$_progress%',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'TIP.\n\n${tips[currentTipIndex]}',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      currentTipIndex =
                          (currentTipIndex - 1 + tips.length) % tips.length;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      currentTipIndex = (currentTipIndex + 1) % tips.length;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
