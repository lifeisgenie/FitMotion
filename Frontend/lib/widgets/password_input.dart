import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final bool isPasswordVisible;
  final ValueChanged<bool> onVisibilityChanged;
  final String labelText;

  PasswordField({
    required this.controller,
    required this.isPasswordVisible,
    required this.onVisibilityChanged,
    required this.labelText,
  });

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        controller: widget.controller,
        obscureText: !widget.isPasswordVisible, // 비밀번호 안보이게 설정
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: TextStyle(color: Colors.white54),
          // 활성화 상태의 밑줄 색상 설정
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white54),
          ),
          // 포커스 상태의 밑줄 색상 설정
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          // 비밀번호를 볼 수 있게 만드는 토글
          suffixIcon: IconButton(
            icon: Icon(
              widget.isPasswordVisible
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: Colors.white54,
            ),
            onPressed: () {
              widget.onVisibilityChanged(!widget.isPasswordVisible);
            },
          ),
        ),
      ),
    );
  }
}
