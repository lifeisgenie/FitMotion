import 'package:FitMotion/pages/feedback_list.dart';
import 'package:FitMotion/pages/login.dart';
import 'package:FitMotion/pages/profile.dart';
import 'package:FitMotion/pages/search.dart';
import 'package:FitMotion/pages/setting.dart';
import 'package:FitMotion/widgets/bottom_navigatorBar.dart';
import 'package:FitMotion/widgets/exercise_card.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Index extends StatefulWidget {
  @override
  _Index createState() => _Index();
}

class _Index extends State<Index> {
  int _selectedIndex = 2;

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt');

    // 로그인 화면으로 이동
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

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

      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: screenWidth * 0.05,
                  right: screenWidth * 0.04,
                  // bottom: screenHeight * 0.01,
                  top: screenHeight * 0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '서강 님',
                    style: TextStyle(
                      fontSize: screenWidth * 0.1,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _logout();
                    },
                    child: Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Text(
                        '로그아웃',
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: screenWidth * 0.05, right: screenWidth * 0.05),
              child: Row(
                children: [
                  Text(
                    'Beautiful ',
                    style: TextStyle(
                      fontSize: screenWidth * 0.1,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '자세!',
                    style: TextStyle(
                      fontSize: screenWidth * 0.1,
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            Padding(
              padding: EdgeInsets.only(
                  left: screenWidth * 0.05, right: screenWidth * 0.05),
              child: Text(
                '자세 교정',
                style: TextStyle(
                    fontSize: screenWidth * 0.06,
                    color: Colors.white), // 0.6로 수정함
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Container(
              height: screenHeight * 0.7, // ExerciseCard가 차지할 최대 높이

              child: ExerciseCard(), // ExerciseCard 위젯을 사용합니다.
            ),
            /* Container(
  height: screenHeight * 0.7, // 전체 화면 높이의 70%
  child: ExerciseCard(), // ExerciseCard 위젯을 사용합니다.
),
            */
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
