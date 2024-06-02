import 'package:flutter/material.dart';
import 'login.dart'; // login.dart 파일을 import 합니다.

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
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Text(
                '신규 회원님!',
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
              SizedBox(
                width: double.infinity, // 버튼의 너비를 텍스트 필드와 동일하게 설정
                child: ElevatedButton(
                  onPressed: () {
                    // 저장하기 버튼 클릭 시 login.dart로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Login()), // Login 클래스로 이동
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text(
                    '저장하기',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: double.infinity, // 버튼의 너비를 텍스트 필드와 동일하게 설정
                child: ElevatedButton(
                  onPressed: () {
                    // 나중에 입력하기 버튼 클릭 시 처리할 로직 추가
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text(
                    '나중에 입력하기',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
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



// 황동혁 회원님! -> 신규회원님!
// Scaffold의 body를 SingleChildScrollView로 감싸서 키보드가 올라올 때 화면이 스크롤되도록 설정.
// GestureDetector를 사용하여 화면 외부를 클릭했을 때 키보드가 내려가도록 설정.
// 나중에하기 -> 뒤로가기로 변경
// 저장하기 누르면 Navigator.push를 통해 login.dart로 이동