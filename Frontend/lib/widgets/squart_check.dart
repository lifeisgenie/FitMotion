import 'dart:io';

import 'package:FitMotion/service/camera.dart';
import 'package:FitMotion/service/render_data.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'dart:math';

class SquartCheck extends StatefulWidget {
  final double exerciseId;
  final String exerciseName;

  SquartCheck({required this.exerciseId, required this.exerciseName});

  @override
  _SquartCheckState createState() => _SquartCheckState();
}

class _SquartCheckState extends State<SquartCheck> {
  CameraController? _controller;
  List<CameraDescription> cameras = []; // 사용 가능한 카메라 목록
  bool _check = false; // 스쿼트 상태를 확인하는 변수

  List<dynamic>? _data; // 모델에서 가져온 데이터
  int _imageHeight = 0; // 이미지 높이
  int _imageWidth = 0; // 이미지 너비
  int x = 1; // 플레이스홀더 변수

  @override
  void initState() {
    super.initState();
    _loadModel();
    _initializeCamera();
  }

  // 카메라를 초기화하는 함수
  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    if (cameras != null && cameras!.isNotEmpty) {
      _controller = CameraController(cameras![1], ResolutionPreset.high);
      await _controller?.initialize();
      setState(() {});
    }
  }

  // 인식 결과를 설정하는 함수
  _setRecognitions(data, imageHeight, imageWidth) {
    if (!mounted) {
      return;
    }
    setState(() {
      _data = data;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  // 모델을 로드하는 함수
  Future<void> _loadModel() async {
    try {
      await Tflite.loadModel(
        model:
            "assets/posenet_mv1_075_float_from_checkpoints.tflite", // 모델 불러오기
        // model: "assets/1.tflite", // movenet(이건 안되더라 // 수정필요)
      );
      print('모델 로드 성공');
    } catch (e) {
      print('모델 로드 실패: $e');
    }
  }

  // 스쿼트 확인 상태를 갱신하는 함수
  void updateCheckValue(bool value) {
    if (mounted) {
      setState(() {
        _check = value;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('AI 스쿼트'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: <Widget>[
          if (cameras != null && cameras!.isNotEmpty)
            Camera(
              exerciseName: widget.exerciseName,
              exerciseId: widget.exerciseId,
              cameras: cameras, // 카메라 목록 전달
              setRecognitions: _setRecognitions, // 인식 결과 설정 함수 전달
              check: _check, // check 변수 전달
            ),
          if (_data != null)
            RenderData(
              data: _data ?? [], // 인식 결과 데이터 전달
              previewH: max(_imageHeight, _imageWidth), // 프리뷰 높이 설정
              previewW: min(_imageHeight, _imageWidth), // 프리뷰 너비 설정
              screenH: screen.height, // 화면 높이
              screenW: screen.width, // 화면 너비
              controller: _controller!, // 카메라 컨트롤러 전달
              check: _check, // 스쿼트 확인 상태 전달
              updateCheckValue:
                  updateCheckValue, // 스쿼트 확인 상태 갱신 함수 전달 (스쿼트 중이면 녹화)
            ),
        ],
      ),
    );
  }
}
