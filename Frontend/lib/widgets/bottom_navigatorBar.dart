import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: screenHeight * 0.1, // 화면 높이의 10%로 설정
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: onTap,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '검색',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: '피드백',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '프로필',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '설정',
          ),
        ],
        selectedItemColor: Colors.amber[800], // 선택된 항목의 색상
        unselectedItemColor: Colors.grey[500], // 선택되지 않은 항목의 색상
        showUnselectedLabels: true, // 선택되지 않은 항목에 라벨 표시
        selectedFontSize: screenHeight * 0.02, // 선택된 항목의 라벨 글꼴 크기
        unselectedFontSize: screenHeight * 0.015, // 선택되지 않은 항목의 라벨 글꼴 크기
        iconSize: screenWidth * 0.08, // 아이콘 크기
      ),
    );
  }
}
