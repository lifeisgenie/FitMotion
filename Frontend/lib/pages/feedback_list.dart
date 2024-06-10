import 'dart:convert';

import 'package:FitMotion/pages/index.dart';
import 'package:FitMotion/pages/profile.dart';
import 'package:FitMotion/pages/search.dart';
import 'package:FitMotion/pages/setting.dart';
import 'package:FitMotion/widgets/bottom_navigatorBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class FeedbackList extends StatefulWidget {
  @override
  _FeedbackList createState() => _FeedbackList();
}

class _FeedbackList extends State<FeedbackList> {
  late Future<List<Map<String, dynamic>>> FeedbackLists;

  @override
  void initState() {
    super.initState();
    FeedbackLists = fetchFeedbackData();
  }

  int _selectedIndex = 1;

  Future<List<Map<String, dynamic>>> fetchFeedbackData() async {
    try {
      await dotenv.load(fileName: ".env");
      final String baseUrl = dotenv.env['BASE_URL']!;
      final Uri url = Uri.parse('$baseUrl/feedback/list/1');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonString = utf8.decode(response.bodyBytes);
        Map<String, dynamic> responseData = json.decode(jsonString);
        List<dynamic> data = responseData['data']['feedback_list'];

        print('피드백 리스트 조회 성공');
        return data.map((item) {
          Map<String, dynamic> exerciseData = item['exercise'];
          String date = formatDate(item['created_date']);
          String time = formatTime(item['created_date']);
          return {
            'fd_id': item['fd_id'] as int,
            'exercise': {
              'exerciseName': exerciseData['exerciseName'] as String,
              'exerciseCategory': exerciseData['exerciseCategory'] as String,
              'exerciseExplain': exerciseData['exerciseExplain'] as String,
              'exerciseUrl': exerciseData['exerciseUrl'] as String,
            },
            'date': date,
            'time': time,
          };
        }).toList();
      } else {
        throw Exception('피드백 리스트 조회 실패');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error fetching feedback data: $e');
    }
  }

// 날짜 변환
  String formatDate(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    String date = '${dateTime.month}/${dateTime.day}';
    return date; // 날짜만 반환
  }

// 시간 변환
  String formatTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    String time =
        '${_formatTime(dateTime.hour)}:${dateTime.minute}${dateTime.hour < 12 ? '오전' : '오후'}';

    return time; // 시간만 반환
  }

// 오전 오후 확인
  String _formatTime(int hour) {
    if (hour == 0) {
      return '12';
    } else if (hour > 12) {
      return '${hour - 12}';
    } else {
      return '$hour';
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SearchPage()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Index()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SettingsPage()),
        );
        break;
    }
  }

  final List<Map<String, String>> feedbackData = [
    {
      'exercise_url': './assets/images/squat.jpg',
      'exercise_name': '스쿼트',
      'content': '피드백피드백피드백피드백피드백피드백피드백피드백피드백피드백피드백피드백피드백피드백피드백피드백피드백피드백피드백피드백',
      'date': '05/07',
      'time': '12:10pm'
    },
    {
      'exercise_url': './assets/images/bench_press.jpg',
      'exercise_name': '벤치프레스',
      'content': '피드백 내용피드백피드백피드백피드백피드백피드백피드백피드백피드백피드백피드백피드백피드백피드백피드백피드백피드백피드백',
      'date': '05/08',
      'time': '10:00am'
    },
  ];

  @override
  Widget build(BuildContext context) {
    TextEditingController _searchController = TextEditingController();

    void _clearSearch() {
      _searchController.clear(); // 입력된 텍스트를 지우기
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text('피드백 목록'),
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: _clearSearch,
                child: Text(
                  '검색 초기화',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenHeight * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: '운동 검색',
                  hintStyle: TextStyle(color: Colors.white54),
                  prefixIcon: Icon(Icons.search, color: Colors.white54),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                '검색 결과',
                style: TextStyle(
                  fontSize: screenWidth * 0.05,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Expanded(
                child: ListView(
                  children: feedbackData.map((feedback) {
                    return FeedbackItem(
                      exercise_url: feedback['exercise_url']!,
                      exercise_name: feedback['exercise_name']!,
                      content: feedback['content']!,
                      date: feedback['date']!,
                      time: feedback['time']!,
                    );
                  }).toList(),
                ),
              ),
              // Expanded(
              //     child: FutureBuilder<List<Map<String, String>>>(
              //         future: futureFeedbackData,
              //         builder: (context, snapshot) {
              //           if (snapshot.connectionState == ConnectionState.waiting) {
              //             return Center(child: CircularProgressIndicator());
              //           } else if (snapshot.hasError) {
              //             return Center(child: Text('데이터를 불러오는데 실패했습니다.'));
              //           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              //             return Center(child: Text('데이터가 존재하지 않습니다.'));
              //           } else {
              //             final feedbackData = snapshot.data!;
              //             return ListView(
              //               children: feedbackData.map((item) {
              //                 return FeedbackItem(
              //  exercise_url: feedback['exercise_url']!,
              // exercise_name: feedback['exercise_name']!,
              // content: feedback['content']!,
              // date: feedback['date']!,
              // time: feedback['time']!,
              //                 );
              //               }).toList(),
              //             );
              //           }
              //         })),
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

class FeedbackItem extends StatelessWidget {
  final String exercise_url;
  final String exercise_name;
  final String content;
  final String date;
  final String time;

  FeedbackItem(
      {required this.exercise_url,
      required this.exercise_name,
      required this.content,
      required this.date,
      required this.time});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[850],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(exercise_url),
        ),
        title: Text(
          exercise_name,
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          overflow: TextOverflow.ellipsis,
          content,
          style: TextStyle(color: Colors.white70),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              date,
              style: TextStyle(color: Colors.white54),
            ),
            Text(
              time,
              style: TextStyle(color: Colors.white54),
            ),
          ],
        ),
      ),
    );
  }
}
