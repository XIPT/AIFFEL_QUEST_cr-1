import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _JellyfishScreenState createState() => _JellyfishScreenState();
}

class _JellyfishScreenState extends State<MainScreen> {
  String result = "결과가 여기에 표시됩니다."; // 초기 결과 메시지

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Jellyfish"),
        centerTitle: true, // 타이틀을 중앙으로 정렬
        backgroundColor: Colors.blue, // AppBar 색상
        leading: Padding(
          padding: EdgeInsets.all(8.0),
          child: Image.asset('assets/jellyfish.jpg'), // 왼쪽 상단 아이콘
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.asset(
                'assets/jellyfish.jpg',
                width: 300,
                height: 300,
              ),
            ),
            SizedBox(height: 20),

            // 예측 결과 출력
            Text(
              result,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // 버튼 2개
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await fetchPrediction("predicted_label");
                  },
                  child: Text(
                    "predicted", // 왼쪽 버튼: 젤리피쉬 예측
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () async {
                    await fetchPrediction("prediction_score");
                  },
                  child: Text(
                    "prediction", // 오른쪽 버튼: 확률 예측
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 서버에서 데이터 가져오기
  Future<void> fetchPrediction(String key) async {
    try {
      final enteredUrl = 'https://e36a-180-70-132-82.ngrok-free.app/'; // 올바른 URL 사용
      final response = await http.get(
        Uri.parse(enteredUrl + "sample"), // API 호출
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': '69420',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          result = "$key: ${data[key] ?? '값 없음'}"; // null 방지
        });
      } else {
        setState(() {
          result = "서버 오류: ${response.statusCode}";
        });
      }
      debugPrint(result);
    } catch (e) {
      setState(() {
        result = "에러 발생: $e";
      });
    }
  }
}