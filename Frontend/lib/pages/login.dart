import 'dart:convert';

import 'package:FitMotion/pages/index.dart';
import 'package:FitMotion/pages/signup_screen.dart';
import 'package:FitMotion/widgets/password_input.dart';
import 'package:FitMotion/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  Future<void> _login() async {
    final email = _idController.text;
    final password = _passwordController.text;
    final String baseUrl = dotenv.env['BASE_URL']!;
    final Uri url = Uri.parse('$baseUrl/user/login');

    // final response = await http.post(
    //   url,
    //   headers: {
    //     'Content-Type': 'application/json',
    //   },
    //   body: jsonEncode({
    //     'email': email,
    //     'password': password,
    //   }),
    // );

    // if (response.statusCode == 200) {
    //   // 성공적으로 로그인됨
    //   print('Login successful');
    // final responseData = jsonDecode(response.body);
    // final accessToken = responseData['accessToken'];
    // final refreshToken = responseData['refreshToken'];

    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setString('accessToken', accessToken);
    // await prefs.setString('refreshToken', refreshToken);

    // // 홈 화면으로 이동
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => Index()));
    // } else {
    //   // 로그인 실패
    //   print('Failed to login: ${response.statusCode}');
    // }
  }

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '로그인',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            buildTextField(_idController, '아이디'),
            SizedBox(height: 16),
            PasswordField(
              controller: _passwordController,
              isPasswordVisible: _isPasswordVisible,
              labelText: '비밀번호 확인',
              onVisibilityChanged: (isVisible) {
                setState(() {
                  _isPasswordVisible = isVisible;
                });
              },
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: Size(double.infinity, 48),
              ),
              child: Text(
                '로그인',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '계정이 없으신가요?',
                  style: TextStyle(color: Colors.white54),
                ),
                SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    // 회원가입 버튼 누를 때 실행될 코드
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => SignUpScreen()),
                    );
                  },
                  child: Text('회원가입하기'),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              // children: [
              //   _buildSocialLoginButton('assets/kakao.png'),
              //   SizedBox(width: 16),
              //   _buildSocialLoginButton('assets/naver.png'),
              //   SizedBox(width: 16),
              //   _buildSocialLoginButton('assets/google.png'),
              // ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialLoginButton(String assetPath) {
    return InkWell(
      onTap: () {
        // 소셜 로그인 버튼 누를 때 실행될 코드
      },
      child: Image.asset(
        assetPath,
        width: 40,
        height: 40,
      ),
    );
  }
}
