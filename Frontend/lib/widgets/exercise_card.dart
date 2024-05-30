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
  final List<Map<String, String>> imageData = [
    {
      'imageUrl': './assets/images/squat.jpg',
      'name': '스쿼트',
      'part': '대퇴사두근, 대둔근, 척추기립근',
      'description': '전신 운동으로 하체 근력을 키우는 데 효과적입니다.'
    },
    {
      'imageUrl': './assets/images/squat.jpg',
      'name': '스쿼트',
      'part': '대퇴사두근, 대둔근, 척추기립근',
      'description': '전신 운동으로 하체 근력을 키우는 데 효과적입니다.'
    },
    {
      'imageUrl': './assets/images/squat.jpg',
      'name': '벤치프레스',
      'part': '대흉근, 삼두근, 전면 삼각근',
      'description': '가슴 근육을 발달시키는 데 효과적인 운동입니다.'
    },
    {
      'imageUrl': './assets/images/squat.jpg',
      'name': '데드리프트',
      'part': '대퇴이두근, 척추기립근, 둔근',
      'description': '허리와 하체를 강화하는 데 매우 효과적인 운동입니다.'
    },
  ];

  // Future<List<Map<String, String>>> fetchImageData() async {
  //   await dotenv.load(fileName: ".env");
  //   final String baseUrl = dotenv.env['BASE_URL']!;
  //   final Uri url = Uri.parse('$baseUrl/url');
  //   final response = await http.get(url);

  // if (response.statusCode == 200) {
  //     List<dynamic> imageData = jsonDecode(response.body);
  //     return imageData.map((item) {
  //       return {
  //         'imageUrl': item['imageUrl'] as String,
  //         'name': item['name'] as String,
  //         'part': item['part'] as String,
  //         'description': item['description'] as String,
  //       };
  //     }).toList();
  //   } else {
  //     throw Exception('데이터를 불러오는 데에 실패했습니다.');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final List<Widget> imageSliders = imageData
        .map((item) => GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ExerciseDetail()),
                );
              },
              child: Card(
                margin: EdgeInsets.only(
                    left: screenWidth * 0.016, right: screenWidth * 0.016),
                color: Colors.grey[900],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: screenWidth * 0.04,
                      right: screenWidth * 0.04,
                      top: screenHeight * 0.02,
                      bottom: screenHeight * 0.02),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(item['imageUrl']!,
                          fit: BoxFit.cover, height: screenHeight * 0.3),
                      SizedBox(height: screenHeight * 0.015),
                      Text(
                        item['name']!,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.015),
                      Text(
                        item['part']!,
                        style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                      ),
                      // SizedBox(height: screenHeight * 0.015),
                      // Text(
                      //   item['description']!,
                      //   style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                      // ),
                    ],
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
}
