import 'dart:convert';

import 'package:FitMotion/pages/index.dart';
import 'package:FitMotion/pages/profile.dart';
import 'package:FitMotion/pages/search.dart';
import 'package:FitMotion/pages/setting.dart';
import 'package:FitMotion/widgets/bottom_navigatorBar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FeedbackList extends StatefulWidget {
  @override
  _FeedbackList createState() => _FeedbackList();
}

class _FeedbackList extends State<FeedbackList> {
  // late Future<List<Map<String, String>>> futureFeedbackData;
  @override
  void initState() {
    super.initState();
    // futureFeedbackData = fetchFeedbackData();
  }

  int _selectedIndex = 1;

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
      'imageUrl': '',
      'title': '스쿼트 5회차',
      'sets': '4세트',
      'date': '05/07',
      'time': '12:10pm'
    },
    {
      'imageUrl': '',
      'title': '벤치프레스 3회차',
      'sets': '3세트',
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

    return Scaffold(
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
                    imageUrl: feedback['imageUrl']!,
                    title: feedback['title']!,
                    sets: feedback['sets']!,
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
            //                   imageUrl: item['imageUrl']!,
            //                   title: item['title']!,
            //                   sets: item['sets']!,
            //                   date: item['date']!,
            //                   time: item['time']!,
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
    );
  }
}

class FeedbackItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String sets;
  final String date;
  final String time;

  FeedbackItem(
      {required this.imageUrl,
      required this.title,
      required this.sets,
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
            // backgroundImage: NetworkImage(imageUrl),
            ),
        title: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          sets,
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
