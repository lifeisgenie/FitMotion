import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final String name = '황동혁';
  final String email = 'ggani@gmail.com';
  final int consecutiveDays = 4;
  final int totalDays = 7;
  final int totalTime = 4; // 시간 단위로 누적 시간 설정

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('프로필'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              '$name 회원님',
              style: TextStyle(fontSize: 24, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              email,
              style: TextStyle(fontSize: 16, color: Colors.white60),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            Text(
              '달성 현황',
              style: TextStyle(fontSize: 20, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildStatCard('연속 출석', '$consecutiveDays일', 16, 24),
                  _buildStatCard('누적 출석', '$totalDays일', 16, 24),
                  _buildStatCardWithIcon(
                      '누적 시간', '$totalTime시간', Icons.access_time, 16, 24),
                  _buildActionCard('개인정보 수정', Icons.person, 16, 16),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // 뒤로가기 버튼 클릭 시 처리할 로직 추가
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text(
                '뒤로가기',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String label, String value, double labelFontSize, double valueFontSize) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: labelFontSize, color: Colors.white60),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(fontSize: valueFontSize, color: Colors.blue),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCardWithIcon(String label, String value, IconData icon,
      double labelFontSize, double valueFontSize) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white60, size: 40),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontSize: labelFontSize, color: Colors.white60),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(fontSize: valueFontSize, color: Colors.blue),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
      String label, IconData icon, double labelFontSize, double valueFontSize) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white60, size: 40),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontSize: labelFontSize, color: Colors.blue),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ProfilePage(),
    theme: ThemeData.dark(), // 다크 모드 테마 설정
  ));
}
