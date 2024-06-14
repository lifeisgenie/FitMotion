import 'dart:convert';

import 'package:FitMotion/pages/feedback_list.dart';
import 'package:FitMotion/pages/login.dart';
import 'package:FitMotion/pages/profile.dart';
import 'package:FitMotion/pages/search.dart';
import 'package:FitMotion/pages/setting.dart';
import 'package:FitMotion/widgets/bottom_navigatorBar.dart';
import 'package:FitMotion/widgets/exercise_card.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Index extends StatefulWidget {
  @override
  _Index createState() => _Index();
}

class _Index extends State<Index> {
  late String username = "UnKnown";

  int _selectedIndex = 2;

  // 로그아웃
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // 로그인 화면으로 이동
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchUserDetail();
  }

  // 유저 데이터 불러오기
  Future<void> fetchUserDetail() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String email = prefs.getString('email') ?? '';
      if (email != "") {
        setState(() {});
      }
      await dotenv.load(fileName: ".env");
      final String baseUrl = dotenv.env['BASE_URL']!;
      final Uri url = Uri.parse('$baseUrl/user/profile/detail/$email');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final utf8DecodedBody = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> responseData = json.decode(utf8DecodedBody);
        final Map<String, dynamic> data = responseData['data'];

        setState(() {
          username = data['username'];
        });
      } else {
        throw Exception('회원 로드 실패');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // bottomNavigationBar 함수
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
                    username,
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
                    fontSize: screenWidth * 0.06, color: Colors.white),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Container(
              height: screenHeight * 0.7, // ExerciseCard가 차지할 최대 높이

              child: ExerciseCard(), // ExerciseCard
            ),
            SizedBox(height: screenHeight * 0.02),
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
