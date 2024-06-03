import 'dart:convert';

import 'package:FitMotion/pages/record_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ExerciseDetail extends StatefulWidget {
  final String exerciseName;

  ExerciseDetail({required this.exerciseName});

  @override
  _ExerciseDetail createState() => _ExerciseDetail();
}

class _ExerciseDetail extends State<ExerciseDetail> {
  final String title = '스쿼트';
  final String muscles = '대퇴사두근, 대둔근, 척추기립근';
  final String description =
      '스쿼트는 웨이트 트레이닝의 가장 대표적인 운동 중 하나이며, 데드리프트, 벤치 프레스와 함께 웨이트 트레이닝의 트로이카 운동으로 꼽힌다. 중량을 거루는 스포츠인 파워리프팅 중 하나이다.';

  late String exerciseUrl;
  late String exerciseCategory;
  late String exerciseExplain;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchExerciseDetail(widget.exerciseName);
  }

  Future<void> fetchExerciseDetail(String exerciseName) async {
    await dotenv.load(fileName: ".env");
    final String baseUrl = dotenv.env['BASE_URL']!;
    final Uri url =
        Uri.parse('$baseUrl/user/exercise/?exerciseName=$exerciseName');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        exerciseUrl = data['exerciseUrl'];
        exerciseName = data['exerciseName'];
        exerciseCategory = data['exerciseCategory'];
        exerciseExplain = data['exerciseExplain'];
        isLoading = false;
      });
    } else {
      throw Exception('운동 상세 로드 실패');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('운동 설명'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Expanded(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.asset(
                    exerciseUrl,
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Text(
                      '운동 설명',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(fontSize: 28, color: Colors.white),
                      ),
                      SizedBox(height: 8),
                      Text(
                        exerciseCategory,
                        style: TextStyle(fontSize: 16, color: Colors.white60),
                      ),
                      SizedBox(height: 20),
                      Text(
                        '운동 설명',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      SizedBox(height: 10),
                      Text(
                        exerciseExplain,
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                      SizedBox(height: 40),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RecordScreen(
                                    exerciseName: widget.exerciseName,
                                  ),
                                ));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 32.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: Text(
                            '교정 시작하기',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
