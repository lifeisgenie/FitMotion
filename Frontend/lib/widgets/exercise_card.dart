import 'dart:convert';

import 'package:FitMotion/pages/exercise_detail.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ExerciseCard extends StatefulWidget {
  // late Future<List<Map<String, String>>> futureImageData;

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

  Future<List<Map<String, String>>> fetchExercises() async {
    try {
      await dotenv.load(fileName: ".env");
      final String baseUrl = dotenv.env['BASE_URL']!;
      final Uri url = Uri.parse('$baseUrl/user/exercise/list');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonString = utf8.decode(response.bodyBytes);
        Map<String, dynamic> json = jsonDecode(jsonString);
        List<dynamic> data = json['exerciseList'];
        print("Received data: $data");
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
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final List<Map<String, String>> exercises = snapshot.data!;
            final screenHeight = MediaQuery.of(context).size.height;
            final screenWidth = MediaQuery.of(context).size.width;

            final List<Widget> imageSliders = exercises
                .map((item) => GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ExerciseDetail(
                                  exerciseName: item['exerciseName']!)),
                        );
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
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: screenHeight *
                          0.76, // 화면 높이의 76%로 설정 (Container의 하위에 4% 여백이 생기도록 설정)
                      aspectRatio: 2.0,
                      enlargeCenterPage: false,
                      scrollDirection: Axis.horizontal,
                      autoPlay: true,
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
