import 'dart:io';
import 'dart:typed_data';

import 'package:FitMotion/pages/feedback.dart';
import 'package:FitMotion/widgets/squart_check.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'dart:math' as math;

import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

typedef void Callback(List<dynamic> list, int h, int w);

class Camera extends StatefulWidget {
  final List<CameraDescription> cameras;
  final Callback setRecognitions;
  final bool check;

  Camera({
    required this.cameras,
    required this.setRecognitions,
    required this.check,
  });

  @override
  _CameraState createState() => new _CameraState();
}

class _CameraState extends State<Camera> {
  CameraController? controller;
  bool isDetecting = false;
  bool isRecording = false;
  List<Uint8List> _frames = [];
  late String _videoPath;
  final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
  late DateTime startRecordingTime;

  @override
  void initState() {
    super.initState();
    if (widget.cameras.isEmpty) {
      print('카메라를 못찾음');
    } else {
      print("카메라 불러옴");
      controller = CameraController(
        widget.cameras[1], // 카메라 리스트의 첫 번째 카메라 사용
        ResolutionPreset.high, // 해상도 설정
      );
      controller?.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
        startImageStream();
      });
    }
  }

  @override
  void didUpdateWidget(Camera oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.check != oldWidget.check) {
      setCheck(widget.check);
    }
  }

  void setCheck(bool value) {
    print('스쿼트 확인 상태: $value');
    if (value == true) {
      print("시작");
      _startRecording();
    } else {
      print("실행");
      _stopRecording();
    }
  }

  void _processCameraImage(CameraImage image) {
    // 각 플레인의 데이터 가져오기
    final Plane planeY = image.planes[0];
    final Plane planeU = image.planes[1];
    final Plane planeV = image.planes[2];

    // 이미지 크기 가져오기
    final int width = image.width;
    final int height = image.height;

    // YUV 포맷으로 데이터 병합
    Uint8List byteData = Uint8List(width * height * 3 ~/ 2);

    int i = 0;
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        byteData[i++] = planeY.bytes[y * planeY.bytesPerRow + x];
      }
    }

    for (int y = 0; y < height ~/ 2; y++) {
      for (int x = 0; x < width; x += 2) {
        byteData[i++] = planeV.bytes[(y * planeV.bytesPerRow) + x];
        byteData[i++] = planeU.bytes[(y * planeU.bytesPerRow) + x];
      }
    }

    // 프레임 리스트에 추가
    _frames.add(byteData);
  }

  // 녹화 시작 함수
  Future<void> _startRecording() async {
    await _flutterFFmpeg.execute('-version');
    final directory = await getApplicationDocumentsDirectory();
    _videoPath =
        '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.mp4';
    startRecordingTime = DateTime.now();

    setState(() {
      isRecording = true; // 녹화 상태를 true로 설정
    });
  }

  // 녹화 중지 함수
  Future<void> _stopRecording() async {
    print("녹화 상태 $isRecording ");
    setState(() {
      isRecording = false; // 녹화 상태를 false로 설정
    });

    // 프레임 데이터를 비디오 파일로 저장
    await _saveVideoFile();

    // 프레임 데이터 리스트 초기화
    _frames.clear();
  }

  // 프레임 데이터를 비디오 파일로 저장하는 함수
  Future<void> _saveVideoFile() async {
    final outputPath = _videoPath;
    final inputFilePath = '${outputPath}.raw';

    // raw 프레임 데이터를 파일로 작성
    final file = File(inputFilePath);
    final sink = file.openWrite();
    for (final frame in _frames) {
      sink.add(frame);
    }
    await sink.close();

    // 프레임 데이터를 적절하게 저장했는지 확인
    print('Frame data saved to $inputFilePath');

    final Duration recordingDuration =
        DateTime.now().difference(startRecordingTime);
    final int recordingDurationInSeconds = recordingDuration.inSeconds;

    // FFmpeg를 사용하여 raw 프레임 데이터를 mp4로 변환
    final ffmpegCommand =
        '-f rawvideo -pix_fmt nv21 -s 1280x720 -r 8 -i $inputFilePath -vf "transpose=3" -t $recordingDurationInSeconds $outputPath';
    await _flutterFFmpeg.execute(ffmpegCommand);

    print('Video saved to $outputPath');
    Future.delayed(Duration(seconds: 1), () async {
      try {
        final result = await ImageGallerySaver.saveFile(outputPath);
        print('저장 완료: $result');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyFeedback()),
        );
      } catch (e) {
        print("실패 ㅜㅜ ");
      }
    });
  }

  void startImageStream() {
    if (controller != null && controller!.value.isInitialized) {
      controller?.startImageStream((CameraImage img) {
        if (!isDetecting) {
          if (isRecording) {
            _processCameraImage(img); // 프레임 데이터를 처리
          }
          isDetecting = true;

          int startTime = DateTime.now().millisecondsSinceEpoch;

          Tflite.runPoseNetOnFrame(
            bytesList: img.planes.map((plane) {
              return plane.bytes;
            }).toList(),
            imageHeight: img.height,
            imageWidth: img.width,
            numResults: 1,
            rotation: -90,
            threshold: 0.1,
            nmsRadius: 10,
          ).then((recognitions) {
            int endTime = DateTime.now().millisecondsSinceEpoch;

            widget.setRecognitions(recognitions!, img.height, img.width);

            isDetecting = false;
          });
        }
      });
    }
  }

  void stopImageStream() {
    if (controller != null && controller!.value.isStreamingImages) {
      controller?.stopImageStream();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return Container();
    }

    var tmp = MediaQuery.of(context).size;
    var screenH = math.max(tmp.height, tmp.width);
    var screenW = math.min(tmp.height, tmp.width);
    tmp = controller!.value.previewSize!;
    var previewH = math.max(tmp.height, tmp.width);
    var previewW = math.min(tmp.height, tmp.width);
    var screenRatio = screenH / screenW;
    var previewRatio = previewH / previewW;

    return OverflowBox(
      maxHeight:
          screenRatio > previewRatio ? screenH : screenW / previewW * previewH,
      maxWidth:
          screenRatio > previewRatio ? screenH / previewH * previewW : screenW,
      child: CameraPreview(controller!),
    );
  }
}
