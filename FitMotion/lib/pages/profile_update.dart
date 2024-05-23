import 'package:flutter/material.dart';

class ProfileUpdatePage extends StatefulWidget {
  @override
  _ProfileUpdatePageState createState() => _ProfileUpdatePageState();
}

class _ProfileUpdatePageState extends State<ProfileUpdatePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  bool isNameFilled = false;
  bool isPhoneFilled = false;
  bool isEmailFilled = false;

  @override
  void initState() {
    super.initState();
    nameController.addListener(() {
      setState(() {
        isNameFilled = nameController.text.isNotEmpty;
      });
    });
    phoneController.addListener(() {
      setState(() {
        isPhoneFilled = phoneController.text.isNotEmpty;
      });
    });
    emailController.addListener(() {
      setState(() {
        isEmailFilled = emailController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 143, 65, 65),
        title: Text(
          '개인정보 수정',
          style: TextStyle(
            fontSize: 24, // 글꼴 크기
            color: Colors.white, // 글꼴 색상
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            _buildLabel('이름'),
            _buildTextField(nameController, '이름을 입력하세요', isNameFilled),
            SizedBox(height: 20),
            _buildLabel('전화번호'),
            _buildTextField(phoneController, '전화번호를 입력하세요', isPhoneFilled),
            SizedBox(height: 20),
            _buildLabel('이메일'),
            _buildTextField(emailController, '이메일을 입력하세요', isEmailFilled),
            SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // 저장 버튼 클릭 시 처리할 로직
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
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
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(color: Colors.white, fontSize: 16),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String hintText, bool isFilled) {
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
        suffixIcon: Icon(
          Icons.check,
          color: isFilled ? Colors.blue : Colors.grey,
        ),
      ),
      style: TextStyle(color: Colors.white),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ProfileUpdatePage(),
  ));
}
