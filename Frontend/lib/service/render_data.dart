import 'dart:io';

import 'package:FitMotion/pages/feedback.dart';
import 'package:FitMotion/widgets/squart_check.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

class RenderData extends StatefulWidget {
  final List<dynamic> data; // 추적 데이터 리스트
  final int previewH; // 미리보기 높이
  final int previewW; // 미리보기 너비
  final double screenH; // 화면 높이
  final double screenW; // 화면 너비
  final CameraController controller;
  final bool check;
  final Function(bool) updateCheckValue;

  RenderData({
    required this.data,
    required this.previewH,
    required this.previewW,
    required this.screenH,
    required this.screenW,
    required this.controller,
    required this.check,
    required this.updateCheckValue,
  });

  @override
  _RenderDataState createState() => _RenderDataState();
}

class _RenderDataState extends State<RenderData> {
  Map<String, List<double>>? inputArr; // 신체 부위와 해당 좌표를 저장하는 맵

  // 영상을 담을 리스트
  List<File> recordedFiles = [];

  int ch = 0;

  // 스쿼트 확인 상태를 갱신하는 함수
  void _updateCheck(bool value) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.updateCheckValue(value);
    });
  }

  String exercise = 'squat'; // 현재 운동
  double upperRange = 300; // 스쿼트 상한선
  double lowerRange = 500; // 스쿼트 하한선
  bool midCount = false; // 중간 카운트 플래그
  bool isCorrectPosture = true; // 올바른 자세 플래그
  int _counter = 0; // 스쿼트 카운트
  Color correctColor = Colors.transparent; // 자세에 따른 색상 변경
  double shoulderLY = 0; // 왼쪽 어깨 Y 좌표
  double shoulderRY = 0; // 오른쪽 어깨 Y 좌표
  double kneeRY = 0; // 오른쪽 무릎 Y 좌표
  double kneeLY = 0; // 왼쪽 무릎 Y 좌표
  bool squatUp = false; // 스쿼트 상위 위치 플래그
  String whatToDo = '포즈를 확인중...'; // 현재 상태

  // 각 신체 부위의 위치를 저장하는 변수들
  var leftEyePos = Vector(0, 0);
  var rightEyePos = Vector(0, 0);
  var leftShoulderPos = Vector(0, 0);
  var rightShoulderPos = Vector(0, 0);
  var leftHipPos = Vector(0, 0);
  var rightHipPos = Vector(0, 0);
  var leftElbowPos = Vector(0, 0);
  var rightElbowPos = Vector(0, 0);
  var leftWristPos = Vector(0, 0);
  var rightWristPos = Vector(0, 0);
  var leftKneePos = Vector(0, 0);
  var rightKneePos = Vector(0, 0);
  var leftAnklePos = Vector(0, 0);
  var rightAnklePos = Vector(0, 0);

  @override
  void initState() {
    inputArr = new Map();
    midCount = false;
    isCorrectPosture = true;
    _counter = 0;
    correctColor = Colors.red;
    shoulderLY = 0;
    shoulderRY = 0;
    kneeRY = 0;
    kneeLY = 0;
    squatUp = true;
  }

  // 운동에 따른 자세를 체크하는 함수
  bool _postureAccordingToExercise(Map<String, List<double>> poses) {
    print(poses);
    setState(() {
      shoulderLY = poses['leftShoulder']?[1] ?? 0.0;
      shoulderRY = poses['rightShoulder']?[1] ?? 0.0;
      kneeLY = poses['leftKnee']?[1] ?? 0.0;
      kneeRY = poses['rightKnee']?[1] ?? 0.0;
    });

    if (exercise == 'squat') {
      if (squatUp) {
        return (poses['leftShoulder']?[1] ?? 0.0) < 320 &&
            (poses['leftShoulder']?[1] ?? 0.0) > 280 &&
            (poses['rightShoulder']?[1] ?? 0.0) < 320 &&
            (poses['rightShoulder']?[1] ?? 0.0) > 280 &&
            (poses['rightKnee']?[1] ?? 0.0) > 570 &&
            (poses['leftKnee']?[1] ?? 0.0) > 570;
      } else {
        return (poses['leftShoulder']?[1] ?? 0.0) > 475 &&
            (poses['rightShoulder']?[1] ?? 0.0) > 475;
      }
    }
    return false;
  }

// 자세가 올바른지 체크하는 함수
  _checkCorrectPosture(Map<String, List<double>> poses) {
    print(poses);
    if (_postureAccordingToExercise(poses)) {
      if (!isCorrectPosture) {
        setState(() {
          isCorrectPosture = true;
          correctColor = Colors.green;
        });
      }
    } else {
      if (isCorrectPosture) {
        setState(() {
          isCorrectPosture = false;
          correctColor = Colors.red;
        });
      }
    }
  }

// 스쿼트 카운팅 로직을 처리하는 함수
  Future<void> _countingLogic(Map<String, List<double>> poses) async {
    if (poses != null) {
      _checkCorrectPosture(poses);
      print(whatToDo);

      if (isCorrectPosture && squatUp && midCount == false) {
        _updateCheck(true);
        // 올바른 초기 자세일 때
        squatUp = !squatUp;
        isCorrectPosture = false;
        setState(() {
          whatToDo = '내려갑니다!';
          correctColor = Colors.green;
        });
      }

      // 스쿼트를 다 내렸을 때
      if (isCorrectPosture && !squatUp && midCount == false) {
        midCount = true;
        isCorrectPosture = false;
        squatUp = !squatUp;
        setState(() {
          whatToDo = '올라옵니다!';
          correctColor = Colors.green;
        });
      }

      // 다시 올라왔을 때
      if (midCount &&
          (poses['leftShoulder']?[1] ?? 0) < 320 &&
          (poses['leftShoulder']?[1] ?? 0) > 280 &&
          (poses['rightShoulder']?[1] ?? 0) < 320 &&
          (poses['rightShoulder']?[1] ?? 0) > 280) {
        incrementCounter();
        midCount = false;
        squatUp = !squatUp;
        setState(() {
          whatToDo = '자세를 다시 확인중...';
        });
        _updateCheck(false);
      }
    }
  }

  // 스쿼트 카운트를 증가시키는 함수
  void incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // keypoints 정보를 받아와 위치를 저장하는 함수
    void _getKeyPoints(k, x, y) {
      // 각 신체 부위에 해당하는 위치를 저장
      if (k["part"] == 'leftEye') {
        leftEyePos.x = x - 230;
        leftEyePos.y = y - 45;
      }
      if (k["part"] == 'rightEye') {
        rightEyePos.x = x - 230;
        rightEyePos.y = y - 45;
      }
      if (k["part"] == 'leftShoulder') {
        leftShoulderPos.x = x - 230;
        leftShoulderPos.y = y - 45;
      }
      if (k["part"] == 'rightShoulder') {
        rightShoulderPos.x = x - 230;
        rightShoulderPos.y = y - 45;
      }
      if (k["part"] == 'leftElbow') {
        leftElbowPos.x = x - 230;
        leftElbowPos.y = y - 45;
      }
      if (k["part"] == 'rightElbow') {
        rightElbowPos.x = x - 230;
        rightElbowPos.y = y - 45;
      }
      if (k["part"] == 'leftWrist') {
        leftWristPos.x = x - 230;
        leftWristPos.y = y - 45;
      }
      if (k["part"] == 'rightWrist') {
        rightWristPos.x = x - 230;
        rightWristPos.y = y - 45;
      }
      if (k["part"] == 'leftHip') {
        leftHipPos.x = x - 230;
        leftHipPos.y = y - 45;
      }
      if (k["part"] == 'rightHip') {
        rightHipPos.x = x - 230;
        rightHipPos.y = y - 45;
      }
      if (k["part"] == 'leftKnee') {
        leftKneePos.x = x - 230;
        leftKneePos.y = y - 45;
      }
      if (k["part"] == 'rightKnee') {
        rightKneePos.x = x - 230;
        rightKneePos.y = y - 45;
      }
      if (k["part"] == 'leftAnkle') {
        leftAnklePos.x = x - 230;
        leftAnklePos.y = y - 45;
      }
      if (k["part"] == 'rightAnkle') {
        rightAnklePos.x = x - 230;
        rightAnklePos.y = y - 45;
      }
    }

    // keypoints를 화면에 렌더링하는 함수
    List<Widget> _renderKeypoints() {
      var lists = <Widget>[];
      widget.data.forEach((re) {
        var list = re["keypoints"].values.map<Widget>((k) {
          var _x = k["x"];
          var _y = k["y"];
          var scaleW, scaleH, x, y;

          // 화면 비율에 맞게 스케일 조정
          if (widget.screenH / widget.screenW >
              widget.previewH / widget.previewW) {
            scaleW = widget.screenH / widget.previewH * widget.previewW;
            scaleH = widget.screenH;
            var difW = (scaleW - widget.screenW) / scaleW;
            x = (_x - difW / 2) * scaleW;
            y = _y * scaleH;
          } else {
            scaleH = widget.screenW / widget.previewW * widget.previewH;
            scaleW = widget.screenW;
            var difH = (scaleH - widget.screenH) / scaleH;
            x = _x * scaleW;
            y = (_y - difH / 2) * scaleH;
          }
          inputArr![k['part']] = [x, y];

          // 좌우 반전
          if (x > 320) {
            var temp = x - 320;
            x = 320 - temp;
          } else {
            var temp = 320 - x;
            x = 320 + temp;
          }

          _getKeyPoints(k, x, y);

          // 신체 부위 위치에 따라 텍스트 표시
          return Positioned(
            left: x - 230,
            top: y - 50,
            width: 100,
            height: 15,
            child: Container(
              child: Text(
                // "● ${k["part"]}",
                "●",
                style: TextStyle(
                  color: Color.fromRGBO(37, 213, 253, 1.0),
                  fontSize: 12.0,
                ),
              ),
            ),
          );
        }).toList();

        _countingLogic(inputArr!); // 자세 확인 및 카운트 로직 호출
        inputArr!.clear(); // 배열 초기화

        lists..addAll(list); // 리스트에 추가
      });

      return lists;
    }

    return Stack(
      children: <Widget>[
        // CustomPaint를 사용하여 선을 그리는 Stack
        Stack(
          children: [
            CustomPaint(
              painter:
                  MyPainter(left: leftShoulderPos, right: rightShoulderPos),
            ),
            CustomPaint(
              painter: MyPainter(left: leftElbowPos, right: leftShoulderPos),
            ),
            CustomPaint(
              painter: MyPainter(left: leftWristPos, right: leftElbowPos),
            ),
            CustomPaint(
              painter: MyPainter(left: rightElbowPos, right: rightShoulderPos),
            ),
            CustomPaint(
              painter: MyPainter(left: rightWristPos, right: rightElbowPos),
            ),
            CustomPaint(
              painter: MyPainter(left: leftShoulderPos, right: leftHipPos),
            ),
            CustomPaint(
              painter: MyPainter(left: leftHipPos, right: leftKneePos),
            ),
            CustomPaint(
              painter: MyPainter(left: leftKneePos, right: leftAnklePos),
            ),
            CustomPaint(
              painter: MyPainter(left: rightShoulderPos, right: rightHipPos),
            ),
            CustomPaint(
              painter: MyPainter(left: rightHipPos, right: rightKneePos),
            ),
            CustomPaint(
              painter: MyPainter(left: rightKneePos, right: rightAnklePos),
            ),
            CustomPaint(
              painter: MyPainter(left: leftHipPos, right: rightHipPos),
            ),
          ],
        ),
        // keypoints를 렌더링하는 Stack
        Stack(children: _renderKeypoints()),
        // 바닥에 텍스트와 색상을 표시하는 Align 위젯
        Positioned(
          top: 16.0,
          right: 16.0,
          child: SizedBox(
            width: 85,
            height: 30,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: widget.check ? Colors.red : Colors.grey,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                textAlign: TextAlign.center,
                widget.check ? '녹화중' : '녹화 대기',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment(0.0, 1.0),
          child: SizedBox(
            height: 60, // 필요에 따라 높이 조절
            width: widget.screenW,
            child: Container(
              decoration: BoxDecoration(
                color: correctColor, // 자세가 맞으면 초록색, 아니면 빨간색
                // borderRadius: BorderRadius.only(
                //   topLeft: Radius.circular(25.0),
                //   topRight: Radius.circular(25),
                //   bottomLeft: Radius.circular(25.0),
                //   bottomRight: Radius.circular(25),
                // ),
              ),
              child: Center(
                child: Text(
                  '$whatToDo\n횟수: ${_counter.toString()}', // 현재 상태와 카운트 표시
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// 2D 벡터 클래스로 x, y 좌표 저장
class Vector {
  double x, y;
  Vector(this.x, this.y);
}

// CustomPainter를 상속받아 선을 그리는 클래스
class MyPainter extends CustomPainter {
  Vector left;
  Vector right;
  MyPainter({required this.left, required this.right});
  @override
  void paint(Canvas canvas, Size size) {
    final p1 = Offset(left.x, left.y);
    final p2 = Offset(right.x, right.y);
    final paint = Paint()
      ..color = Colors.blue // 선 색상 설정
      ..strokeWidth = 4; // 선 두께 설정
    canvas.drawLine(p1, p2, paint); // 선 그리기
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false; // 재페인트 조건 설정
  }
}
