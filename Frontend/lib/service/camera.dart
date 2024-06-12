import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:FitMotion/pages/feedback.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;

import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

// 콜백 타입 정의
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
  bool isDetecting = false; // 인식 중인지 여부
  bool isRecording = false; // 녹화 중인지 여부
  List<Uint8List> _frames = []; // 프레임 리스트
  late String _videoPath; // 비디오 파일 경로
  final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg(); // FFmpeg 인스턴스
  late DateTime startRecordingTime; // 녹화 시작 시간

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

  // 스쿼트 상태에 따라서 check 변경
  @override
  void didUpdateWidget(Camera oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.check != oldWidget.check) {
      setCheck(widget.check);
    }
  }

  // check에 따라서 녹화 On / Off
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

  // 캡쳐된 이미지 처리 함수 -> 이미지 크기와 상태 조정
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
    final directory = await getApplicationDocumentsDirectory(); // 디렉토리 설정
    _videoPath =
        '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.mp4'; // 경로 설정
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
    print('프레임 데이터 저장 완료 :  $inputFilePath');

    final Duration recordingDuration =
        DateTime.now().difference(startRecordingTime);
    final int recordingDurationInSeconds = recordingDuration.inSeconds;

    // FFmpeg를 사용하여 raw 프레임 데이터를 mp4로 변환
    final ffmpegCommand =
        '-f rawvideo -pix_fmt nv21 -s 1280x720 -r 8 -i $inputFilePath -vf "transpose=3" -t $recordingDurationInSeconds $outputPath';
    await _flutterFFmpeg.execute(ffmpegCommand);

    print('비디오 저장 완료 :  $outputPath');
    Future.delayed(Duration(seconds: 1), () async {
      try {
        final result = await ImageGallerySaver.saveFile(outputPath);
        await _uploadVideoToServer(outputPath);
      } catch (e) {
        print("실패 ㅜㅜ ");
      }
    });
  }

  // 서버에 비디오 파일을 업로드하는 함수
  Future<void> _uploadVideoToServer(String filePath) async {
    try {
      await dotenv.load(fileName: ".env");
      final String baseUrl = dotenv.env['AI_URL']!;
      final Uri url = Uri.parse('$baseUrl/upload');
      var request = http.MultipartRequest('POST', url);
      request.files.add(await http.MultipartFile.fromPath('video', filePath));
      var response = await request.send();

      if (response.statusCode == 200) {
        print('비디오 전송 성공');

// 응답 헤더에서 content-type을 가져옴
        final contentType = response.headers['content-type'];

        // content-type에서 boundary 값을 추출
        final boundaryMatch = RegExp('boundary=(.*)').firstMatch(contentType!);
        if (boundaryMatch == null) {
          print('Boundary not found in content-type');
          return;
        }

        final boundary = boundaryMatch.group(1)!;

        // 응답 데이터를 byte 리스트로 읽음
        final responseBodyBytes = await response.stream.toBytes();

        // byte 리스트를 문자열로 디코딩
        final responseBodyString = utf8.decode(responseBodyBytes);

        // boundary를 사용하여 multipart 데이터 파싱
        final parts = responseBodyString.split('--$boundary');
        String? jsonData;
        // Map<String, List<int>>? fileData;
        File mp4File;
        // 각 파트에 대해 처리
        for (final part in parts) {
          if (part.trim().isEmpty) {
            continue; // 공백 또는 빈 파트는 무시
          }

          // Content-Disposition에서 name을 추출하여 파트의 역할을 결정
          final dispositionMatch = RegExp('name="([^"]*)"').firstMatch(part);
          if (dispositionMatch == null) {
            continue;
          }
          final name = dispositionMatch.group(1);

          if (name == 'json') {
            final jsonContent = part.split('\r\n\r\n')[1].trim();
            final jsonData = json.decode(jsonContent);
            print('JSON Data: $jsonData');
          } else if (name == 'file') {
            final fileContent = part.split('\r\n\r\n')[1].trim();
            // Assuming fileContent is the file content in bytes
            // Write it to a file
            final file = File('received_video.mp4');
            await file.writeAsBytes(fileContent.codeUnits);
            print('Video file received and saved as \'received_video.mp4\'');
            mp4File = file;
            Navigator.push(
              context,
              MaterialPageRoute(
                // builder: (context) => MyFeedback(videoFile: file),
                builder: (context) => MyFeedback(videoFile: mp4File),
              ),
            );
          }
        }
      } else {
        print('전송 실패');
      }
    } catch (e) {
      print('비디오 전송 에러: $e');
    }
  }

  // 이미지 스트림 시작 함수
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
            // 인식 결과 설정
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
    // 카메라가 없으면 빈 화면
    if (controller == null || !controller!.value.isInitialized) {
      return Container();
    }

    // 화면 크기 가져오기
    var tmp = MediaQuery.of(context).size;
    var screenH = math.max(tmp.height, tmp.width); // 화면 높이
    var screenW = math.min(tmp.height, tmp.width); // 화면 너비
    tmp = controller!.value.previewSize!;
    var previewH = math.max(tmp.height, tmp.width); // 카메라 미리보기 높이
    var previewW = math.min(tmp.height, tmp.width); // 카메라 미리보기 너비
    var screenRatio = screenH / screenW; // 화면 비율
    var previewRatio = previewH / previewW; // 미리보기 비율

    return OverflowBox(
      // 화면 비율과 미리보기 비율을 비교하여 최대 높이 설정
      maxHeight:
          screenRatio > previewRatio ? screenH : screenW / previewW * previewH,
      // 화면 비율과 미리보기 비율을 비교하여 최대 너비 설정
      maxWidth:
          screenRatio > previewRatio ? screenH / previewH * previewW : screenW,
      child: CameraPreview(controller!), // 카메라 미리보기 위젯 반환
    );
  }
}
