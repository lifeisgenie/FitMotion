import 'package:FitMotion/pages/record_screen.dart';
import 'package:FitMotion/widgets/squart_check.dart';
import 'package:flutter/material.dart';

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

  late String exerciseUrl = "./assets/images/squat.jpg";
  late String exerciseCategory = "하체±";
  late String exerciseExplain = "내려갔다 올라오거라";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchExerciseDetail(widget.exerciseName);
  }

  Future<void> fetchExerciseDetail(String exerciseName) async {
    try {
      await dotenv.load(fileName: ".env");
      final String baseUrl = dotenv.env['BASE_URL']!;
      final Uri url = Uri.parse('$baseUrl/user/exercise/detail/$exerciseName');
      print(widget.exerciseName);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final utf8DecodedBody = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> responseData = json.decode(utf8DecodedBody);
        final Map<String, dynamic> data = responseData['data'];

        setState(() {
          exerciseUrl = data['exerciseUrl'] ?? exerciseUrl;
          exerciseCategory = data['exerciseCategory'] ?? exerciseCategory;
          exerciseExplain = data['exerciseExplain'] ?? exerciseExplain;
          isLoading = false;
        });
      } else {
        throw Exception('운동 상세 로드 실패');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('운동 설명',
            style: TextStyle(
              fontFamily: 'NotoSans',
              fontWeight: FontWeight.w600,
            )),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Image.asset(
                        exerciseUrl,
                        width: double.infinity,
                        height: 400,
                        fit: BoxFit.cover,
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
                            widget.exerciseName,
                            style: TextStyle(
                                fontFamily: 'NotoSans',
                                fontWeight: FontWeight.w600,
                                fontSize: 28,
                                color: Colors.white),
                          ),
                          SizedBox(height: 8),
                          Text(
                            exerciseCategory,
                            style: TextStyle(
                                fontFamily: 'NotoSans',
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.white60),
                          ),
                          SizedBox(height: 20),
                          Text(
                            '운동 설명',
                            style: TextStyle(
                                fontFamily: 'NotoSans',
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                color: Colors.white),
                          ),
                          SizedBox(height: 10),
                          Text(
                            exerciseExplain,
                            style: TextStyle(
                                fontFamily: 'NotoSans',
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.white70),
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
                                  ),
                                );
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
                                style: TextStyle(
                                    fontFamily: 'NotoSans',
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontSize: 16),
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
    );
  }
}
