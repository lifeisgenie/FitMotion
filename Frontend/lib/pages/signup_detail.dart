import 'package:flutter/material.dart';

class SignUpDetailPage extends StatelessWidget {
  final TextEditingController ageController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('추가 정보 입력'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              '황동혁 회원님!',
              style: TextStyle(fontSize: 24, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              '추가정보를 입력해주세요.',
              style: TextStyle(fontSize: 16, color: Colors.white60),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            _buildTextField(ageController, '나이'),
            SizedBox(height: 20),
            _buildTextField(heightController, '신장'),
            SizedBox(height: 20),
            _buildTextField(weightController, '몸무게'),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // 저장하기 버튼 클릭 시 처리할 로직 추가
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text(
                '저장하기',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // 나중에 입력하기 버튼 클릭 시 처리할 로직 추가
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text(
                '나중에 입력하기',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white54),
        filled: true,
        fillColor: Colors.grey[800],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      style: TextStyle(color: Colors.white),
      keyboardType: hintText == '나이' || hintText == '몸무게'
          ? TextInputType.number
          : TextInputType.text,
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: SignUpDetailPage(),
    theme: ThemeData.dark(), // 다크 모드 테마 설정
  ));
}
