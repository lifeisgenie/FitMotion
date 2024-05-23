import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  final List<Map<String, String>> exercises = [
    {
      'title': '스쿼트',
      'subtitle': '대퇴사두근, 대둔근...',
      'image': 'https://example.com/squat.jpg' // 이미지 URL을 실제 URL로 변경
    },
    {
      'title': '데드리프트',
      'subtitle': '허벅지 뒤쪽(햄스트...',
      'image': 'https://example.com/deadlift.jpg' // 이미지 URL을 실제 URL로 변경
    },
    {
      'title': '벤치 프레스',
      'subtitle': '대흉근, 소흉근...',
      'image': 'https://example.com/benchpress.jpg' // 이미지 URL을 실제 URL로 변경
    },
    {
      'title': '런지',
      'subtitle': '허벅지 뒤쪽(햄스트링...',
      'image': 'https://example.com/lunge.jpg' // 이미지 URL을 실제 URL로 변경
    },
    // 다른 항목들 추가
    {
      'title': '푸쉬업',
      'subtitle': '대흉근, 삼두근...',
      'image': 'https://example.com/pushup.jpg' // 이미지 URL을 실제 URL로 변경
    },
    {
      'title': '풀업',
      'subtitle': '광배근, 이두근...',
      'image': 'https://example.com/pullup.jpg' // 이미지 URL을 실제 URL로 변경
    },
    {
      'title': '푸쉬업',
      'subtitle': '대흉근, 삼두근...',
      'image': 'https://example.com/pushup.jpg' // 이미지 URL을 실제 URL로 변경
    },
    {
      'title': '풀업',
      'subtitle': '광배근, 이두근...',
      'image': 'https://example.com/pullup.jpg' // 이미지 URL을 실제 URL로 변경
    },
    {
      'title': '푸쉬업',
      'subtitle': '대흉근, 삼두근...',
      'image': 'https://example.com/pushup.jpg' // 이미지 URL을 실제 URL로 변경
    },
    {
      'title': '풀업',
      'subtitle': '광배근, 이두근...',
      'image': 'https://example.com/pullup.jpg' // 이미지 URL을 실제 URL로 변경
    },
    {
      'title': '푸쉬업',
      'subtitle': '대흉근, 삼두근...',
      'image': 'https://example.com/pushup.jpg' // 이미지 URL을 실제 URL로 변경
    },
    {
      'title': '풀업',
      'subtitle': '광배근, 이두근...',
      'image': 'https://example.com/pullup.jpg' // 이미지 URL을 실제 URL로 변경
    },
    {
      'title': '푸쉬업',
      'subtitle': '대흉근, 삼두근...',
      'image': 'https://example.com/pushup.jpg' // 이미지 URL을 실제 URL로 변경
    },
    {
      'title': '풀업',
      'subtitle': '광배근, 이두근...',
      'image': 'https://example.com/pullup.jpg' // 이미지 URL을 실제 URL로 변경
    },
    {
      'title': '푸쉬업',
      'subtitle': '대흉근, 삼두근...',
      'image': 'https://example.com/pushup.jpg' // 이미지 URL을 실제 URL로 변경
    },
    {
      'title': '풀업',
      'subtitle': '광배근, 이두근...',
      'image': 'https://example.com/pullup.jpg' // 이미지 URL을 실제 URL로 변경
    },
    // 필요에 따라 더 많은 항목을 추가
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('자세 교정'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
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
                suffixIcon: Icon(Icons.mic, color: Colors.white54),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 20),
            Text(
              '검색 결과',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.8,
                ),
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  return _buildExerciseCard(exercises[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseCard(Map<String, String> exercise) {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  exercise['image']!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              exercise['title']!,
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            SizedBox(height: 4),
            Text(
              exercise['subtitle']!,
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: SearchPage(),
    theme: ThemeData.dark(), // 다크 모드 테마 설정
  ));
}
