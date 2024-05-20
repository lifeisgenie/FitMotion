import 'package:FitMotion/pages/signup_screen.dart';
import 'package:flutter/material.dart';

class Index extends StatefulWidget {
  @override
  _Index createState() => _Index();
}

class _Index extends State<Index> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: GestureDetector(
        onTap: () => {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => SignUpScreen()),
          )
        },
        child: Text("signup"),
      )),
    );
  }
}
