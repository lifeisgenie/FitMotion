import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class MyFeedback extends StatefulWidget {
  final String exerciseName;
  final double exerciseId;
  final String video_path;
  final String content;

  MyFeedback(
      {required this.exerciseName,
      required this.content,
      required this.video_path,
      required this.exerciseId});

  @override
  _MyFeedback createState() => _MyFeedback();
}

class _MyFeedback extends State<MyFeedback> {
  VideoPlayerController? _controller;
  bool _isVideoEnd = false;
  bool _isLoading = false;
  late String content = widget.content;

  @override
  void initState() {
    super.initState();
    _isLoading = true; // 데이터 로딩 시작
    fetchFeedbackData();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> fetchFeedbackData() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      int UserId = prefs.getInt('userId') ?? 1;
      await dotenv.load(fileName: ".env");
      final String baseUrl = dotenv.env['BASE_URL']!;
      final Uri url = Uri.parse('$baseUrl/user/feedback/save');
      print("비디오 : ${widget.content}");
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "userId": UserId,
          "videoUrl": widget.video_path,
          "content": widget.content,
          "exerciseId": widget.exerciseId,
        }),
      );
      final responseData = jsonDecode(response.body);
      final String message = responseData['message'];
      if (response.statusCode == 201) {
        _controller =
            VideoPlayerController.networkUrl(Uri.parse(widget.video_path))
              ..initialize().then((_) {
                setState(() {
                  _isLoading = false; // 로딩 완료
                });
              });

        _controller?.addListener(() {
          if (_controller!.value.position == _controller!.value.duration) {
            setState(() {
              _isVideoEnd = true;
            });
          } else {
            setState(() {
              _isVideoEnd = false;
            });
          }
        });
      } else {
        print('서버 에러: ${response.statusCode}');
        setState(() {
          _isLoading = false; // 로딩 완료 (에러 처리)
        });
      }
    } catch (e) {
      print('네트워크 에러: $e');
      setState(() {
        _isLoading = false; // 로딩 완료 (에러 처리)
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('AI 운동 피드백'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '스쿼트',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              SizedBox(height: 20),
              Text(
                '영상',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (_controller != null) {
                      if (_controller!.value.isPlaying) {
                        _controller!.pause();
                      } else {
                        _controller!.play();
                      }
                    }
                  });
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (_controller != null && _controller!.value.isInitialized)
                      AspectRatio(
                        aspectRatio: _controller!.value.aspectRatio,
                        child: VideoPlayer(_controller!),
                      )
                    else if (_isLoading)
                      Container(
                        height: 200,
                        color: Colors.grey[800],
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else
                      Container(
                        height: 200,
                        color: Colors.grey[800],
                        child: Center(
                          child: Text('영상을 불러올 수 없습니다.'),
                        ),
                      ),
                    if (_controller == null ||
                        !_controller!.value.isPlaying ||
                        _isVideoEnd)
                      Icon(
                        Icons.play_circle_filled,
                        size: 80,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    if (_controller != null && !_controller!.value.isPlaying)
                      Container(
                        color: Colors.black.withOpacity(0.3),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                'AI 피드백',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  widget.content,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
