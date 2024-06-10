import 'dart:convert';

import 'package:FitMotion/pages/exercise_detail.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ExerciseCard extends StatefulWidget {
  @override
  _ExerciseCardState createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  late Future<List<Map<String, String>>> futureExercises;

  @override
  void initState() {
    super.initState();
    futureExercises = fetchExercises();
  }

  // 운동 목록 불러오기
  Future<List<Map<String, String>>> fetchExercises() async {
    try {
      await dotenv.load(fileName: ".env");
      final String baseUrl = dotenv.env['BASE_URL']!;
      final Uri url = Uri.parse('$baseUrl/user/exercise/list');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonString = utf8.decode(response.bodyBytes);
        Map<String, dynamic> json = jsonDecode(jsonString);
        List<dynamic> data = json['data']['exerciseList'];
        return data.map((item) {
          return {
            'exerciseName': item['exerciseName'] as String,
            'exerciseExplain': item['exerciseExplain'] as String,
            'exerciseUrl': item['exerciseUrl'] as String,
          };
        }).toList();
      } else {
        print('데이터 로드 실패. Status code: ${response.statusCode}');
        throw Exception('데이터 로드 실패');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('운동 불러오기 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, String>>>(
        future: futureExercises,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // 데이터 로딩 중인 경우 로딩
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // 오류 발생 시 오류 메시지 표시
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '데이터를 불러오지 못했습니다.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ),
                ],
              ),
            );
          } else {
            final List<Map<String, String>> exercises = snapshot.data!;
            final screenHeight = MediaQuery.of(context).size.height;
            final screenWidth = MediaQuery.of(context).size.width;
            // 운동 목록에서 각 운동을 나타내는 보여주는 화면
            final List<Widget> imageSliders = exercises
                .map((item) => GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ExerciseDetail(
                                  exerciseName: item['exerciseName']!)),
                        ); // 운동 상세 페이지로 이동
                      },
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 300),
                        child: Card(
                          margin: EdgeInsets.only(
                              left: screenWidth * 0.016,
                              right: screenWidth * 0.016),
                          color: Colors.grey[900],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: screenWidth * 0.04,
                              right: screenWidth * 0.04,
                              top: screenHeight * 0.02,
                              bottom: screenHeight * 0.02,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Image.asset(item['exerciseUrl']!,
                                      fit: BoxFit.cover,
                                      height: screenHeight * 0.3),
                                ),
                                SizedBox(height: screenHeight * 0.015),
                                Text(
                                  item['exerciseName']!,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.015),
                                Text(
                                  overflow: TextOverflow.ellipsis,
                                  item['exerciseExplain']!,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey[500]),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ))
                .toList();

            return Scaffold(
              backgroundColor: Colors.black,
              body: Container(
                child: Container(
                  color: Colors.black,
                  height: screenHeight * 0.45, // 화면 높이의 80%로 설정
                  // Casosel로 슬라이드 나열
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: screenHeight *
                          0.76, // 화면 높이의 76%로 설정 (Container의 하위에 4% 여백이 생기도록 설정)
                      aspectRatio: 2.0, // 카로셀 종횡비를 2:1로 설정
                      enlargeCenterPage: false, // 가운데 페이지 확대 비활성화
                      scrollDirection: Axis.horizontal, // 수평 스크롤 방향 설정
                      autoPlay: true, // 자동 재생 활성화
                    ),
                    items: imageSliders,
                  ),
                ),
              ),
            );
          }
        });
  }
}
