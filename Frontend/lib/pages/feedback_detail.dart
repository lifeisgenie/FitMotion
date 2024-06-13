import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

class FeedbackPage extends StatefulWidget {
  final int fd_id;

  FeedbackPage({required this.fd_id});

  @override
  _FeedbackPage createState() => _FeedbackPage();
}

class _FeedbackPage extends State<FeedbackPage> {
  late String videoUrl = "";
  late DateTime createdDate;
  VideoPlayerController? _controller;
  bool _isVideoEnd = false;

  @override
  void initState() {
    super.initState();
    fetchFeedbackData();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> fetchFeedbackData() async {
    try {
      await dotenv.load(fileName: ".env");
      final String baseUrl = dotenv.env['BASE_URL']!;
      final Uri url =
          Uri.parse('$baseUrl/user/feedback/detail/${widget.fd_id}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final feedbackData = jsonData['data'];
        videoUrl =
            feedbackData['videoUrl'].replaceFirst('./', 'assets/videos/');
        createdDate = DateTime.parse(feedbackData['createdDate']);
        print("불러오기 성공");
        print(videoUrl);

        // Initialize the VideoPlayerController
        _controller = VideoPlayerController.asset(videoUrl)
          ..initialize().then((_) {
            setState(() {});
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

        setState(() {});
      } else {
        print('서버 에러: ${response.statusCode}');
      }
    } catch (e) {
      print('네트워크 에러: $e');
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
                    else
                      Container(
                        height: 200,
                        color: Colors.grey[800],
                        child: Center(
                          child: CircularProgressIndicator(),
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
                  '스쿼트를 할 때, 등과 허리를 곧게 유지하고 무릎이 발끝을 초과하지 않도록 주의해야 합니다. 힘을 발로 전달하고 엉덩이와 다리 근육을 적절히 사용하세요. 호흡을 제어하며 균형을 유지해야 합니다. 이동 범위를 최대한 확보하여 근력과 유연성을 항상 시키세요.',
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
