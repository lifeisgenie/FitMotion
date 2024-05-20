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
      width: 300, // 원하는 너비로 설정
      margin: const EdgeInsets.symmetric(horizontal: 16.0), // 좌우에 16픽셀 마진 추가
      child: TextField(
        controller: widget.controller,
        obscureText: !widget.isPasswordVisible,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: TextStyle(color: Colors.white54),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white54),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
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
