import 'dart:convert';

import 'package:FitMotion/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:http/http.dart' as http;

class SignUpDetailPage extends StatefulWidget {
  final String phone;
  final String email;
  final String password;

  SignUpDetailPage({
    required this.phone,
    required this.email,
    required this.password,
  });

  @override
  _SignUpDetailPageState createState() => _SignUpDetailPageState();
}

class _SignUpDetailPageState extends State<SignUpDetailPage> {
  final TextEditingController ageController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  // 회원가입 함수
  Future<void> _userSignup() async {
    final String phone = widget.phone;
    final String email = widget.email;
    final String password = widget.password;
    final String username = usernameController.text;
    final String age = ageController.text;
    final String height = heightController.text;
    final String weight = weightController.text;

    try {
      await dotenv.load(fileName: ".env");
      final String baseUrl = dotenv.env['BASE_URL']!;
      final Uri url = Uri.parse('$baseUrl/user/signup');
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "email": email,
          "password": password,
          "username": username,
          "age": age,
          "phone": phone,
          "height": height,
          "weight": weight
        }),
      );
      final responseData = jsonDecode(response.body);
      final String message = responseData['message'];

      if (response.statusCode == 201) {
        print('회원가입 성공, 다시 로그인 하세요.');
        _showDialog('회원가입 성공', '회원가입이 완료되었습니다. 다시 로그인 하세요.', true);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Login()),
        );
      } else {
        // 회원가입 실패
        print('회원가입 실패. status code: ${response.statusCode}');
        _showDialog('회원가입 실패', message, false);
      }
    } catch (e) {
      print('회원가입 에러: $e');
    }
  }

  void _showDialog(String title, String content, bool isSuccess) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text("확인"),
              onPressed: () {
                Navigator.of(context).pop();
                if (isSuccess) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

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
              _buildTextField(usernameController, '이름'),
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
                    // 저장하기 버튼 클릭 시 회원가입
                    _userSignup();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
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
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white60,
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

  // 입력
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
      keyboardType: hintText == '나이' || hintText == '몸무게' || hintText == '신장'
          ? TextInputType.number
          : TextInputType.text,
    );
  }
}




// 황동혁 회원님! -> 신규회원님!
// Scaffold의 body를 SingleChildScrollView로 감싸서 키보드가 올라올 때 화면이 스크롤되도록 설정.
// GestureDetector를 사용하여 화면 외부를 클릭했을 때 키보드가 내려가도록 설정.
// 나중에하기 -> 뒤로가기로 변경
// 저장하기 누르면 Navigator.push를 통해 login.dart로 이동