import 'package:FitMotion/pages/index.dart';
import 'package:FitMotion/widgets/bottom_navigatorBar.dart';
import 'package:flutter/material.dart';


class FeedbackList extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('피드백 목록'),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () {},
              child: Text(
                '검색 초기화',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
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
            SizedBox(height: 20),
            Text(
              '최근별',
              style: TextStyle(fontSize: 20, color: Colors.blue),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  FeedbackItem(
                    imageUrl:
                        'https://example.com/exercise1.jpg', // Replace with the actual image URL
                    title: '스쿼트 5회차',
                    sets: '4세트',
                    date: '05/07',
                    time: '12:10pm',
                  ),
                  FeedbackItem(
                    imageUrl:
                        'https://example.com/exercise2.jpg', // Replace with the actual image URL
                    title: '스쿼트 4회차',
                    sets: '2세트',
                    date: '05/05',
                    time: '11:40am',
                  ),
                  FeedbackItem(
                    imageUrl:
                        'https://example.com/exercise3.jpg', // Replace with the actual image URL
                    title: '스쿼트 3회차',
                    sets: '3세트',
                    date: '04/31',
                    time: '15:21pm',
                  ),
                  FeedbackItem(
                    imageUrl:
                        'https://example.com/exercise4.jpg', // Replace with the actual image URL
                    title: '스쿼트 2회차',
                    sets: '5세트',
                    date: '04/28',
                    time: '13:41pm',
                  ),
                  FeedbackItem(
                    imageUrl:
                        'https://example.com/exercise5.jpg', // Replace with the actual image URL
                    title: '스쿼트 1회차',
                    sets: '1세트',
                    date: '04/25',
                    time: '12:11pm',
                  ),
                  FeedbackItem(
                    imageUrl:
                        'https://example.com/exercise1.jpg', // Replace with the actual image URL
                    title: '스쿼트 5회차',
                    sets: '4세트',
                    date: '05/07',
                    time: '12:10pm',
                  ),
                  FeedbackItem(
                    imageUrl:
                        'https://example.com/exercise2.jpg', // Replace with the actual image URL
                    title: '스쿼트 4회차',
                    sets: '2세트',
                    date: '05/05',
                    time: '11:40am',
                  ),
                  FeedbackItem(
                    imageUrl:
                        'https://example.com/exercise3.jpg', // Replace with the actual image URL
                    title: '스쿼트 3회차',
                    sets: '3세트',
                    date: '04/31',
                    time: '15:21pm',
                  ),
                  FeedbackItem(
                    imageUrl:
                        'https://example.com/exercise4.jpg', // Replace with the actual image URL
                    title: '스쿼트 2회차',
                    sets: '5세트',
                    date: '04/28',
                    time: '13:41pm',
                  ),
                  FeedbackItem(
                    imageUrl:
                        'https://example.com/exercise5.jpg', // Replace with the actual image URL
                    title: '스쿼트 1회차',
                    sets: '1세트',
                    date: '04/25',
                    time: '12:11pm',
                  ),
                  FeedbackItem(
                    imageUrl:
                        'https://example.com/exercise1.jpg', // Replace with the actual image URL
                    title: '스쿼트 5회차',
                    sets: '4세트',
                    date: '05/07',
                    time: '12:10pm',
                  ),
                  FeedbackItem(
                    imageUrl:
                        'https://example.com/exercise2.jpg', // Replace with the actual image URL
                    title: '스쿼트 4회차',
                    sets: '2세트',
                    date: '05/05',
                    time: '11:40am',
                  ),
                  FeedbackItem(
                    imageUrl:
                        'https://example.com/exercise3.jpg', // Replace with the actual image URL
                    title: '스쿼트 3회차',
                    sets: '3세트',
                    date: '04/31',
                    time: '15:21pm',
                  ),
                  FeedbackItem(
                    imageUrl:
                        'https://example.com/exercise4.jpg', // Replace with the actual image URL
                    title: '스쿼트 2회차',
                    sets: '5세트',
                    date: '04/28',
                    time: '13:41pm',
                  ),
                  FeedbackItem(
                    imageUrl:
                        'https://example.com/exercise5.jpg', // Replace with the actual image URL
                    title: '스쿼트 1회차',
                    sets: '1세트',
                    date: '04/25',
                    time: '12:11pm',
                  ),
                  FeedbackItem(
                    imageUrl:
                        'https://example.com/exercise1.jpg', // Replace with the actual image URL
                    title: '스쿼트 5회차',
                    sets: '4세트',
                    date: '05/07',
                    time: '12:10pm',
                  ),
                  FeedbackItem(
                    imageUrl:
                        'https://example.com/exercise2.jpg', // Replace with the actual image URL
                    title: '스쿼트 4회차',
                    sets: '2세트',
                    date: '05/05',
                    time: '11:40am',
                  ),
                  FeedbackItem(
                    imageUrl:
                        'https://example.com/exercise3.jpg', // Replace with the actual image URL
                    title: '스쿼트 3회차',
                    sets: '3세트',
                    date: '04/31',
                    time: '15:21pm',
                  ),
                  FeedbackItem(
                    imageUrl:
                        'https://example.com/exercise4.jpg', // Replace with the actual image URL
                    title: '스쿼트 2회차',
                    sets: '5세트',
                    date: '04/28',
                    time: '13:41pm',
                  ),
                  FeedbackItem(
                    imageUrl:
                        'https://example.com/exercise5.jpg', // Replace with the actual image URL
                    title: '스쿼트 1회차',
                    sets: '1세트',
                    date: '04/25',
                    time: '12:11pm',
                  ),
                ],
              ),
            ),
          ],
        ),
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
          backgroundImage: NetworkImage(imageUrl),
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
