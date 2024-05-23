import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = false;
  bool isNotificationEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('환경설정'),
        leading: Icon(Icons.settings),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              '황동혁',
              style: TextStyle(fontSize: 24, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Card(
              color: Colors.grey[850],
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
                      style: TextStyle(fontSize: 16, color: Colors.white54),
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
              color: Colors.grey[850],
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
                      style: TextStyle(fontSize: 16, color: Colors.white54),
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
      inactiveTrackColor: Colors.grey,
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.white54,
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
