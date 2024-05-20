import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 추가

Widget buildTextField(TextEditingController controller, String labelText) {
  // 만약 labelText가 '전화 번호'인 경우에만 숫자만 입력하고 형식을 변환해줌
  if (labelText == '전화번호') {
    return Container(
      width: 300, // 원하는 너비로 설정
      margin: const EdgeInsets.symmetric(horizontal: 16.0), // 좌우에 16픽셀 마진 추가
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.white),
        keyboardType: TextInputType.number, // 숫자 키보드만 허용
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly, //숫자만!
          NumberFormatter(), // 자동하이픈
          LengthLimitingTextInputFormatter(13) //13자리만 입력받도록 하이픈 2개+숫자 11개
        ],
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: Colors.white54),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white54),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  } else {
    // 다른 경우에는 기본 TextField 리턴
    return Container(
      width: 300, // 원하는 너비로 설정
      margin: const EdgeInsets.symmetric(horizontal: 16.0), // 좌우에 16픽셀 마진 추가
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: Colors.white54),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white54),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class NumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex <= 3) {
        if (nonZeroIndex % 3 == 0 && nonZeroIndex != text.length) {
          buffer.write('-');
        }
      } else {
        if (nonZeroIndex % 7 == 0 &&
            nonZeroIndex != text.length &&
            nonZeroIndex > 4) {
          buffer.write('-');
        }
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: TextSelection.collapsed(offset: string.length));
  }
}
