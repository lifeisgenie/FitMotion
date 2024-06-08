import 'dart:io';

import 'package:FitMotion/service/camera.dart';
import 'package:FitMotion/service/render_data.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'dart:math';

class SquartCheck extends StatefulWidget {
  @override
  _SquartCheckState createState() => _SquartCheckState();
}

class _SquartCheckState extends State<SquartCheck> {
  CameraController? _controller;
  List<CameraDescription> cameras = [];
  int _selectedCameraIndex = 0;
  bool _check = false;

  List<dynamic>? _data;
  int _imageHeight = 0;
  int _imageWidth = 0;
  int x = 1;

  @override
  void initState() {
    super.initState();
    _loadModel();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    if (cameras != null && cameras!.isNotEmpty) {
      _controller = CameraController(cameras![1], ResolutionPreset.high);
      await _controller?.initialize();
      setState(() {});
    }
  }

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

  Future<void> _loadModel() async {
    try {
      await Tflite.loadModel(
        model: "assets/posenet_mv1_075_float_from_checkpoints.tflite",
        // model: "assets/1.tflite",
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
      print("check는 $_check");
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
              cameras: cameras,
              setRecognitions: _setRecognitions,
              check: _check, // check 변수 전달
            ),
          if (_data != null)
            RenderData(
              data: _data ?? [],
              previewH: max(_imageHeight, _imageWidth),
              previewW: min(_imageHeight, _imageWidth),
              screenH: screen.height,
              screenW: screen.width,
              controller: _controller!,
              check: _check,
              updateCheckValue: updateCheckValue,
            ),
        ],
      ),
    );
  }
}
