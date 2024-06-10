import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget buildTextField(TextEditingController controller, String labelText) {
  // 만약 labelText가 '전화 번호'인 경우에만 숫자만 입력하고 형식을 변환해줌
  if (labelText == '전화번호') {
    return Container(
      width: 300,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
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
      width: 300,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
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

// 전화번호 형식으로 변환하는 포매터 클래스
class NumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;
    // 입력된 값이 비어있으면 그대로 반환
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      // 첫 번째 3자리마다 하이픈 추가
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex <= 3) {
        if (nonZeroIndex % 3 == 0 && nonZeroIndex != text.length) {
          buffer.write('-');
        }
      } else {
        // 이후 4자리마다 하이픈 추가
        if (nonZeroIndex % 7 == 0 &&
            nonZeroIndex != text.length &&
            nonZeroIndex > 4) {
          buffer.write('-');
        }
      }
    }

    var string = buffer.toString();

    // 새로운 TextEditingValue 반환
    return newValue.copyWith(
        text: string,
        selection: TextSelection.collapsed(offset: string.length));
  }
}
