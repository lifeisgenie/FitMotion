import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'dart:typed_data';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class RecordScreen extends StatefulWidget {
  @override
  _RecordScreen createState() => _RecordScreen();
}

class _RecordScreen extends State<RecordScreen> {
  CameraController? _controller; // 카메라 컨트롤러
  List<CameraDescription>? cameras; // 이용 가능한 카메라 목록
  bool _isRecording = false; // 녹화 상태
  XFile? _videoFile; // 녹화된 비디오 파일
  StreamController<Image>? _imageStreamController; // 이미지 스트림 컨트롤러
  Timer? _frameTimer; // 프레임 타이머
  int _capturedFrameCount = 0; // 캡처된 프레임 수
  int _selectedCameraIndex = 0; // 선택된 카메라 인덱스

  Future<void> _switchCamera() async {
    if (_controller != null && _controller!.value.isInitialized) {
      final cameraCount = cameras?.length ?? 0;
      if (cameraCount < 2) return; // 카메라가 2개 미만인 경우 전환하지 않음
      _selectedCameraIndex = (_selectedCameraIndex + 1) % cameraCount;
      await _controller!.dispose();
      _controller = CameraController(
        cameras![_selectedCameraIndex],
        ResolutionPreset.high,
      );
      await _controller!.initialize();
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeCamera(); // 카메라 초기화
    _imageStreamController = StreamController<Image>(); // 이미지 스트림 컨트롤러 초기화
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras(); // 이용 가능한 카메라 목록 가져오기
    if (cameras != null && cameras!.isNotEmpty) {
      _controller = CameraController(cameras![_selectedCameraIndex],
          ResolutionPreset.high); // 첫 번째 카메라로 컨트롤러 초기화
      await _controller?.initialize(); // 컨트롤러 초기화 완료
      setState(() {});
    }
  }

  Future<void> _startRecording() async {
    if (_controller != null && _controller!.value.isInitialized) {
      final directory =
          await getApplicationDocumentsDirectory(); // 저장 디렉토리 가져오기
      final filePath =
          path.join(directory.path, '${DateTime.now()}.mp4'); // 파일 경로 생성
      await _controller?.startVideoRecording(); // 비디오 녹화 시작
      setState(() {
        _isRecording = true; // 녹화 상태 업데이트
      });
      _frameTimer = Timer.periodic(Duration(milliseconds: 50), (timer) {
        _captureFrame(); // 500밀리초마다 프레임 캡처
      });
    }
  }

  Future<void> _stopRecording() async {
    if (_controller != null && _controller!.value.isRecordingVideo) {
      _videoFile = await _controller?.stopVideoRecording(); // 비디오 녹화 중지
      setState(() {
        _isRecording = false; // 녹화 상태 업데이트
      });
      _frameTimer?.cancel(); // 프레임 타이머 중지
    }
  }

  Future<void> _captureFrame() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      return;
    }

    try {
      final image = await _controller!.takePicture(); // 사진 찍기
      final imageBytes = await image.readAsBytes(); // 이미지 바이트로 읽기
      final img.Image? frame = img.decodeImage(imageBytes); // 이미지 디코딩

      if (frame != null) {
        setState(() {
          _capturedFrameCount++; // 캡처된 프레임 수 증가
        });
        _imageStreamController?.add(Image.memory(
            Uint8List.fromList(img.encodeJpg(frame)))); // 이미지 스트림에 추가

        // 서버로 전송
        await _sendFrameToServer(Uint8List.fromList(img.encodeJpg(frame)));
      }
    } catch (e) {
      print('Error capturing frame: $e'); // 에러 처리
    }
  }

  Future<void> _sendFrameToServer(Uint8List jpgBytes) async {
    try {
      final response = await http.post(
        Uri.parse('http://yourserver.com/upload'), // 서버의 엔드포인트 URL
        headers: {
          'Content-Type': 'application/octet-stream', // 콘텐츠 타입 설정
        },
        body: jpgBytes, // 이미지 데이터 전송
      );

      if (response.statusCode == 200) {
        print('영상 전송 성공'); // 성공 메시지 출력
      } else {
        print('영상 업로드 실패: ${response.statusCode}'); // 실패 메시지 출력
      }
    } catch (e) {
      print('영상 전송 실패: $e'); // 에러 처리
    }
  }

  @override
  void dispose() {
    _controller?.dispose(); // 컨트롤러 해제
    _imageStreamController?.close(); // 이미지 스트림 컨트롤러 닫기
    _frameTimer?.cancel(); // 프레임 타이머 취소
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Record Screen'), // 화면 제목
      ),
      body: Column(
        children: [
          if (_controller != null && _controller!.value.isInitialized)
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height *
                      0.8, // 카메라 프리뷰 높이를 전체 화면의 80%로 설정
                  child: CameraPreview(_controller!), // 카메라 프리뷰
                ),
                Positioned(
                  top: 20,
                  left: 20,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    color: Colors.black54,
                    child: Text(
                      "스쿼트", // 캡처된 프레임 수 표시
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    _switchCamera();
                  },
                  child: Text('Switch Camera'), // 버튼 텍스트
                ),
                Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    color: Colors.black54,
                    child: Text(
                      '$_capturedFrameCount 번 촬영중', // 자막 텍스트
                      style: TextStyle(color: Colors.white, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ElevatedButton(
            onPressed: () async {
              if (_isRecording) {
                await _stopRecording(); // 녹화 중지
              } else {
                await _startRecording(); // 녹화 시작
              }
            },
            child: Text(_isRecording
                ? 'Stop Recording'
                : 'Start Recording'), // 버튼 텍스트 업데이트
          ),
        ],
      ),
    );
  }
}
