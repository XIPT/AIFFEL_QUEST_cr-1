import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("로그인")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: idController,
              decoration: InputDecoration(
                labelText: "ID",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
              obscureText: true, // 비밀번호 숨김 기능
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // 로그인 버튼 클릭 시 개인 정보 입력 화면으로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PersonalInfoScreen()),
                );
              },
              child: Text("로그인"),
            ),
          ],
        ),
      ),
    );
  }
}

class PersonalInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("개인 정보 입력")),
      body: Stack(
        children: [
          // 메인 입력 필드 (중앙 정렬)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(decoration: InputDecoration(labelText: "이름")),
                TextField(decoration: InputDecoration(labelText: "성별")),
                TextField(decoration: InputDecoration(labelText: "생년월일")),
                TextField(decoration: InputDecoration(labelText: "신장")),
                TextField(decoration: InputDecoration(labelText: "체중")),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TestSelectionScreen()),
                    );
                  },
                  child: Text("완료"),
                ),
              ],
            ),
          ),

          // Skip 버튼
          Positioned(
            bottom: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Skip",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TestSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("테스트 선택")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GeneralTestScreen()),
                );
              },
              child: Text("일반인 테스트"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AthleteTestScreen()),
                );
              },
              child: Text("선수용 테스트"),
            ),
          ],
        ),
      ),
    );
  }
}

class AthleteTestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('선수 테스트'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Text(
          '선수 테스트 페이지',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class GeneralTestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("일반인 테스트")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Vo2MaxTestScreen()),
                );
              },
              child: Text("VO2max Test"),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text("기록으로 진단"),
            ),
          ],
        ),
      ),
    );
  }
}

class Vo2MaxTestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("VO2max Test")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TestStartScreen()),
                );
              },
              child: Text("1.6 km 걷기"),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text("2.4 km 달리기"),
            ),
          ],
        ),
      ),
    );
  }
}

class TestStartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("테스트 시작")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TestProgressScreen()),
            );
          },
          child: Text("Test Start"),
        ),
      ),
    );
  }
}

// 테스트 진행 화면
class TestProgressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("테스트 진행 중")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("테스트 진행 중입니다..."),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // "테스트 완료" 버튼 (실제 어플 개발 시에는 없는 버튼)
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TestResultScreen()),
                );
              },
              child: Text("테스트 완료"),
            ),
          ],
        ),
      ),
    );
  }
}

// 테스트 결과 화면
class TestResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("테스트 결과")),
      body: Center(
        child: GestureDetector(
          onTap: () {
            // "테스트 결과 표시" 텍스트를 누르면 홈화면으로 이동
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
                  (Route<dynamic> route) => false, // 모든 이전 페이지 제거
            );
          },
          child: Text(
            "테스트 결과 표시",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ),
      ),
    );
  }
}

// 홈 화면
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("홈 화면")),
      body: Stack(
        children: [
          // 메인 버튼 UI (가운데 정렬)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // 세로 중앙 정렬
              crossAxisAlignment: CrossAxisAlignment.center, // 가로 중앙 정렬
              children: [
                ElevatedButton(
                  onPressed: () {
                    print("트레이닝 관리 클릭됨");
                  },
                  child: Text("트레이닝 관리"),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // "러닝 시작" 버튼 클릭 시 RunningStartScreen으로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RunningStartScreen()),
                    );
                  },
                  child: Text("러닝 시작"),
                ),
              ],
            ),
          ),

          // 로그아웃 버튼 (오른쪽 하단)
          Positioned(
            bottom: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent, // 버튼 색상 변경 가능
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "로그아웃",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RunningStartScreen extends StatefulWidget {
  @override
  _RunningStartScreenState createState() => _RunningStartScreenState();
}

class _RunningStartScreenState extends State<RunningStartScreen> {
  String selectedType = "Select Type"; // 선택된 러닝 타입을 저장하는 변수

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("러닝 시작")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 세로 중앙 정렬
          children: [
            // Start 버튼
            ElevatedButton(
              onPressed: () {
                print("러닝 시작!");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              child: Text("Start"),
            ),
            SizedBox(height: 20), // 버튼 간 간격 조절

            // Select Type 버튼 (러닝 타입 선택)
            ElevatedButton(
              onPressed: () {
                _showSelectTypeDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                textStyle: TextStyle(fontSize: 18),
              ),
              child: Text(selectedType),
            ),
          ],
        ),
      ),
    );
  }

// 러닝 타입 선택 다이얼로그
  void _showSelectTypeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("러닝 타입 선택"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("Free Run"),
                onTap: () {
                  setState(() {
                    selectedType = "Free Run";
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("Distance"),
                onTap: () {
                  setState(() {
                    selectedType = "Distance";
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("Time"),
                onTap: () {
                  setState(() {
                    selectedType = "Time";
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("Intensity"),
                onTap: () {
                  setState(() {
                    selectedType = "Intensity";
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("AI Coach"),
                onTap: () {
                  _showAICoachDialog(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

// AI Coach 상세 선택 다이얼로그
  void _showAICoachDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("AI Coach 러닝 선택"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("LSD"),
                onTap: () {
                  setState(() {
                    selectedType = "LSD";
                  });
                  Navigator.pop(context);
                  Navigator.pop(context); // 이전 다이얼로그도 닫음
                },
              ),
              ListTile(
                title: Text("HIIT"),
                onTap: () {
                  setState(() {
                    selectedType = "HIIT";
                  });
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("Tempo"),
                onTap: () {
                  setState(() {
                    selectedType = "Tempo";
                  });
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("Recovery"),
                onTap: () {
                  setState(() {
                    selectedType = "Recovery";
                  });
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}