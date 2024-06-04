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
  bool _isRecording = false;
  int _selectedCameraIndex = 0;
  // 영상을 담을 리스트
  List<File> recordedFiles = [];

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

  // 녹화 시작 함수
  Future<void> _startRecording() async {
    if (!_controller!.value.isRecordingVideo) {
      await _controller!.startVideoRecording();
      _isRecording = true;
      print("Recording started");
    }
  }

// 녹화 종료 함수
  Future<void> _stopRecording() async {
    if (_controller!.value.isRecordingVideo) {
      XFile videoFile = await _controller!.stopVideoRecording();
      recordedFiles.add(File(videoFile.path));
      _isRecording = false;
      print("데이터를 저장했습니다. ${videoFile.path}");

      // 5개의 영상을 녹화하면 URL로 전송
      if (recordedFiles.length >= 5) {
        await _sendVideos(recordedFiles);
        recordedFiles.clear();
      }
    }
  }

  Future<void> _sendVideos(List<File> data) async {
    print("전송!");
    // final url = Uri.parse('YOUR_URL_HERE');
    // 데이터 전송 로직을 여기에 추가
    // 예를 들어, http 패키지를 사용하여 데이터를 전송할 수 있습니다.
    // var response = await http.post(url, body: jsonEncode(data));
    // print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');
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
              cameras: cameras!,
              setRecognitions: _setRecognitions,
            ),
          RenderData(
            data: _data ?? [],
            previewH: max(_imageHeight, _imageWidth),
            previewW: min(_imageHeight, _imageWidth),
            screenH: screen.height,
            screenW: screen.width,
            startRecording: _startRecording,
            stopRecording: _stopRecording,
          ),
        ],
      ),
    );
  }
}
