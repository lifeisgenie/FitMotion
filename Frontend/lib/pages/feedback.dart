import 'package:flutter/material.dart';

class FeedbackPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('AI 운동 피드백'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: () {
                // 다음 화면으로 이동하는 로직을 여기에 추가
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '1세트',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            SizedBox(height: 20),
            Text(
              '영상',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            SizedBox(height: 10),
            Container(
              height: 200,
              color: Colors.grey[800],
              child: Center(
                child: Icon(
                  Icons.play_circle_outline,
                  color: Colors.white,
                  size: 100,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'AI 피드백',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(
                '스쿼트를 할 때, 등과 허리를 곧게 유지하고 무릎이 발끝을 초과하지 않도록 주의해야 합니다. 힘을 발로 전달하고 엉덩이와 다리 근육을 적절히 사용하세요. 호흡을 제어하며 균형을 유지해야 합니다. 이동 범위를 최대한 확보하여 근력과 유연성을 항상 시키세요.',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
