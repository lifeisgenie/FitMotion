import 'package:FitMotion/pages/feedback_list.dart';
import 'package:FitMotion/pages/index.dart';
import 'package:FitMotion/pages/search.dart';
import 'package:FitMotion/pages/setting.dart';
import 'package:FitMotion/widgets/bottom_navigatorBar.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final String name = '황동혁';
  final String email = 'donghyuk@gmail.com';
  final int consecutiveDays = 4;
  final int totalDays = 7;
  final int totalTime = 4; // 시간 단위로 누적 시간 설정

  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SearchPage()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FeedbackList()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Index()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SettingsPage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(
      //   backgroundColor: Colors.black,
      //   title: Text('프로필'),
      //   centerTitle: true,
      // ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 100),
            Text(
              '${widget.name} 회원님',
              style: TextStyle(
                  fontFamily: 'NotoSans',
                  fontWeight: FontWeight.w600,
                  fontSize: 30,
                  color: Colors.white),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 8),
            Text(
              widget.email,
              style: TextStyle(fontSize: 16, color: Colors.white60),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 40),
            Text(
              '달성 현황',
              style: TextStyle(
                  fontFamily: 'NotoSans',
                  fontWeight: FontWeight.w600,
                  fontSize: 30,
                  color: Colors.white),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 0),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildStatCard('연속 출석', '${widget.consecutiveDays}일', 24, 35),
                  _buildStatCard('누적 출석', '${widget.totalDays}일', 24, 35),
                  _buildStatCardWithIcon('누적 시간', '${widget.totalTime}시간',
                      Icons.access_time, 20, 30),
                  _buildActionCard('개인정보', '수정', Icons.person, 24, 24),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
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
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
                fontFamily: 'NotoSans',
                fontWeight: FontWeight.w600,
                fontSize: labelFontSize,
                color: Colors.white),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
                fontFamily: 'NotoSans',
                fontWeight: FontWeight.w600,
                fontSize: valueFontSize,
                color: Colors.blue),
            textAlign: TextAlign.left,
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
      child: Stack(
        children: [
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(
                      fontFamily: 'NotoSans',
                      fontWeight: FontWeight.w600,
                      fontSize: labelFontSize,
                      color: Colors.white),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 8),
                Text(
                  value,
                  style: TextStyle(
                      fontFamily: 'NotoSans',
                      fontWeight: FontWeight.w600,
                      fontSize: valueFontSize,
                      color: Colors.blue),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Icon(
              icon,
              color: Colors.white60,
              size: 50,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(String label1, String label2, IconData icon,
      double labelFontSize, double valueFontSize) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        //
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 8),
          Text(label1,
              style: TextStyle(
                  fontFamily: 'NotoSans',
                  fontWeight: FontWeight.w600,
                  fontSize: labelFontSize,
                  color: Colors.white),
              textAlign: TextAlign.left),
          Text(
            label2,
            style: TextStyle(
                fontFamily: 'NotoSans',
                fontWeight: FontWeight.w600,
                fontSize: labelFontSize,
                color: Colors.white),
            textAlign: TextAlign.left,
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
