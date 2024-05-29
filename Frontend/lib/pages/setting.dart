import 'package:FitMotion/pages/feedback_list.dart';
import 'package:FitMotion/pages/index.dart';
import 'package:FitMotion/pages/profile.dart';
import 'package:FitMotion/pages/search.dart';
import 'package:FitMotion/widgets/bottom_navigatorBar.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = false;
  bool isNotificationEnabled = false;

  int _selectedIndex = 4;

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
    return Scaffold(
      backgroundColor: Colors.black, // 배경색 검은색으로 설정
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 0, 0, 0), // AppBar 배경색
        title: Row(
          children: [
            // SizedBox(width: 16), // 아이콘을 오른쪽으로 이동시키기 위한 SizedBox
            // SizedBox(width: 32233), // 아이콘과 텍스트 사이의 간격 조정
            Text(
              '환경설정',
              style:
                  TextStyle(fontSize: 37, color: Colors.white), // 환경설정 텍스트 색상
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            SizedBox(height: 40),
            Card(
              color: Colors.grey[850], // 카드 배경색 설정
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '계정 설정',
                      style: TextStyle(
                          fontSize: 16, color: Colors.white54), // 텍스트 색상 설정
                    ),
                    SizedBox(height: 10),
                    _buildListItem('프로필 수정', Icons.person, () {
                      // 프로필 수정 페이지로 이동하는 로직 추가
                    }),
                    _buildDivider(),
                    _buildListItem('비밀번호 변경', Icons.lock, () {
                      // 비밀번호 변경 페이지로 이동하는 로직 추가
                    }),
                    _buildDivider(),
                    _buildSwitchItem('알림 설정', isNotificationEnabled, (value) {
                      setState(() {
                        isNotificationEnabled = value;
                      });
                    }),
                    _buildDivider(),
                    _buildSwitchItem('다크 모드', isDarkMode, (value) {
                      setState(() {
                        isDarkMode = value;
                      });
                    }),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Card(
              color: Colors.grey[850], // 카드 배경색 설정
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '더보기',
                      style: TextStyle(
                          fontSize: 16, color: Colors.white54), // 텍스트 색상 설정
                    ),
                    SizedBox(height: 10),
                    _buildListItem('자세히보기', Icons.info, () {
                      // 자세히보기 페이지로 이동하는 로직 추가
                    }),
                    _buildDivider(),
                    _buildListItem('프라이버시 정책', Icons.privacy_tip, () {
                      // 프라이버시 정책 페이지로 이동하는 로직 추가
                    }),
                  ],
                ),
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

  Widget _buildListItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
      onTap: onTap,
    );
  }

  Widget _buildSwitchItem(
      String title, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.blue,
      inactiveThumbColor: Colors.grey,
      inactiveTrackColor: Color.fromARGB(255, 0, 0, 0), // 비활성화된 트랙 색상 설정
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.white54, // 구분선 색상 설정
      height: 1,
      thickness: 1,
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: SettingsPage(),
    theme: ThemeData.dark(), // 다크 모드 테마 설정
  ));
}
