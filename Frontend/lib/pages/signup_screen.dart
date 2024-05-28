import 'package:flutter/material.dart';
import 'package:FitMotion/pages/login.dart';
import 'package:FitMotion/widgets/password_input.dart';
import 'package:FitMotion/widgets/text_input.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _phoneController = TextEditingController();
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _ageController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isPasswordVisible2 = false;
  bool _isSignUpEnabled = false;
  bool _isNext = false;

  @override
  void initState() {
    super.initState();
    _confirmPasswordController.addListener(_validateSignUp);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _idController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _validateSignUp() {
    setState(() {
      _isSignUpEnabled =
          _passwordController.text == _confirmPasswordController.text &&
              _passwordController.text.isNotEmpty &&
              _confirmPasswordController.text.isNotEmpty &&
              _passwordController.text.length >= 8 &&
              _idController.text.length >= 10 &&
              _phoneController.text.length >= 13;
    });
  }

  @override
  void _next() {
    setState(() {
      _isNext = true;
    });
  }

  Future<void> _signUp() async {
    // Your sign-up logic here
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
              '회원가입',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '이미 계정이 있으신가요?',
                  style: TextStyle(color: Colors.white54),
                ),
                SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    // 로그인 버튼 누를 때 실행될 코드
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
                  child: Text('로그인하기'),
                ),
              ],
            ),
            SizedBox(height: 24),
            buildTextField(_phoneController, '전화번호'),
            SizedBox(height: 16),
            buildTextField(_idController, '아이디'),
            SizedBox(height: 16),
            PasswordField(
              controller: _passwordController,
              isPasswordVisible: _isPasswordVisible,
              labelText: '비밀번호',
              onVisibilityChanged: (isVisible) {
                setState(() {
                  _isPasswordVisible = isVisible;
                });
              },
            ),
            SizedBox(height: 8),
            PasswordField(
              controller: _confirmPasswordController,
              isPasswordVisible: _isPasswordVisible2,
              labelText: '비밀번호 확인',
              onVisibilityChanged: (isVisible) {
                setState(() {
                  _isPasswordVisible2 = isVisible;
                });
              },
            ),
            SizedBox(height: 8),
            Text(
              '비밀번호는 최소 8자 이상이어야 합니다',
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isSignUpEnabled ? _next : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isSignUpEnabled
                    ? Colors.blue
                    : const Color.fromARGB(221, 134, 133, 133),
                minimumSize: Size(double.infinity, 48),
              ),
              child: Text(
                '회원가입하기',
                style: _isSignUpEnabled
                    ? TextStyle(color: Colors.white)
                    : TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(height: 16),

            SizedBox(height: 24),
            // 추가된 입력 필드
            if (_isNext)
              Column(
                children: [
                  buildTextField(_heightController, '키'),
                  SizedBox(height: 16),
                  buildTextField(_weightController, '몸무게'),
                  SizedBox(height: 16),
                  buildTextField(_ageController, '나이'),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
