import 'dart:io';
import 'dart:typed_data';
import 'package:FitMotion/pages/feedback.dart';
import 'package:FitMotion/pages/index.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

class RecordScreen extends StatefulWidget {
  final String exerciseName;

  RecordScreen({required this.exerciseName});

  @override
  _RecordScreenState createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  CameraController? _controller;
  List<CameraDescription>? cameras;
  bool _isRecording = false;
  int _selectedCameraIndex = 0;
  late String _videoPath;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    if (cameras != null && cameras!.isNotEmpty) {
      _controller = CameraController(
          cameras![_selectedCameraIndex], ResolutionPreset.high);
      await _controller?.initialize();
      setState(() {});
    }
  }

  Future<void> _startRecording() async {
    if (_controller != null && _controller!.value.isInitialized) {
      try {
        final DateTime now = DateTime.now();
        final String formattedDate =
            '${widget.exerciseName}_{now.year}-${now.month}-${now.day}_${now.hour}-${now.minute}-${now.second}';
        final Directory appDir = await getTemporaryDirectory();
        final String videoDirPath = '${appDir.path}/videos';
        await Directory(videoDirPath).create(recursive: true);
        _videoPath = '$videoDirPath/video_$formattedDate.mp4';

        await _controller!.startVideoRecording();
        setState(() {
          _isRecording = true;
        });
      } catch (e) {
        print('녹화 시작 중 오류 발생: $e');
      }
    }
  }

  Future<void> _stopRecording() async {
    if (_controller != null && _controller!.value.isRecordingVideo) {
      try {
        final XFile videoFile = await _controller!.stopVideoRecording();
        setState(() {
          _isRecording = false;
          _videoPath = videoFile.path;
        });
        if (_videoPath.isNotEmpty) {
          try {
            // Assuming you have a server endpoint to handle video upload
            final Uri serverUri = Uri.parse('');
            final File videoFile = File(_videoPath);
            final String videoName = path.basename(videoFile.path);

            if (!await videoFile.exists()) {
              print('파일이 존재하지 않습니다: $_videoPath');
              return;
            }

            final Uint8List videoBytes = await videoFile.readAsBytes();
            final http.MultipartRequest request =
                http.MultipartRequest('POST', serverUri)
                  ..files.add(http.MultipartFile.fromBytes('video', videoBytes,
                      filename: videoName));

            print('Video path: ghkrdls$_videoPath');
            final http.StreamedResponse response = await request.send();
            if (response.statusCode == 200) {
              print("비디오 전송 완료");
            } else {
              print('비디오 전송 실패. 오류 코드: ${response.statusCode}');
            }
          } catch (e) {
            print('비디오 전송 실패: $e');
          }
        }
      } catch (e) {
        print('녹화 중지 중 오류 발생: $e');
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('영상 촬영'), // 운동 종류 촬영
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          if (_controller != null && _controller!.value.isInitialized)
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context)
                      .size
                      .width, // 카메라 화면의 너비를 화면의 100%로 지정
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: CameraPreview(_controller!),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.03,
                  left: MediaQuery.of(context).size.width * 0.05,
                  child: Container(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.04,
                        right: MediaQuery.of(context).size.width * 0.04,
                        top: MediaQuery.of(context).size.height * 0.01,
                        bottom: MediaQuery.of(context).size.height * 0.01),
                    color: Colors.black54,
                    child: Text(
                      widget.exerciseName,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.05),
                    ),
                  ),
                ),
                Positioned(
                    top: MediaQuery.of(context).size.height * 0.03,
                    right: MediaQuery.of(context).size.width * 0.05,
                    child: IconButton(
                        // Switch camera 버튼을 아이콘 버튼으로 변경
                        icon: _selectedCameraIndex == 0
                            ? Icon(Icons.camera_front)
                            : Icon(Icons.camera_rear),
                        iconSize: MediaQuery.of(context).size.width * 0.1,
                        onPressed: () {
                          if (_controller != null &&
                              _controller!.value.isInitialized) {
                            _selectedCameraIndex =
                                (_selectedCameraIndex + 1) % cameras!.length;
                            _controller = CameraController(
                              cameras![_selectedCameraIndex],
                              ResolutionPreset.high,
                            );
                            _controller!.initialize().then((_) {
                              setState(() {});
                            });
                          }
                        })),
                Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.03,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.03,
                        right: MediaQuery.of(context).size.width * 0.03,
                        top: MediaQuery.of(context).size.height * 0.01,
                        bottom: MediaQuery.of(context).size.height * 0.01),
                    color: Colors.black54,
                    child: Text(
                      _isRecording ? '녹화중' : '녹화준비중',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ElevatedButton(
            onPressed: () {
              if (_isRecording) {
                _showConfirmationModal();
              } else {
                _startRecording();
              }
            },
            child: Text(_isRecording ? 'Stop Recording' : 'Start Recording'),
          ),
        ],
      ),
    );
  }

  void _showConfirmationModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('녹화 중지'),
          content: Text('정말로 녹화를 중지하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 모달 닫기
              },
              child: Text('아니오'),
            ),
            TextButton(
              onPressed: () {
                // _stopRecording(); // 예를 누르면 녹화 중지
                _stopRecording();
                Navigator.of(context).pop();
              },
              child: Text('예'),
            ),
          ],
        );
      },
    );
  }
}
