import 'dart:io';                     // File 객체 사용
import 'package:image_picker/image_picker.dart'; // 카메라 & 갤러리 사용
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '운동 생리학 계산기',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PersonalInfoScreen(),
    );
  }
}

// 🟢 1. 개인정보 입력 화면
class PersonalInfoScreen extends StatefulWidget {
  @override
  _PersonalInfoScreenState createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();

  String _selectedGender = '남성'; // 기본값

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("개인 정보 입력")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // 이름
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "이름"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '이름을 입력해주세요.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),

              // 성별 (Dropdown)
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: InputDecoration(labelText: '성별'),
                items: ['남성', '여성'].map((gender) {
                  return DropdownMenuItem(
                    value: gender,
                    child: Text(gender),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value ?? '남성';
                  });
                },
              ),
              SizedBox(height: 10),

              // 키
              TextFormField(
                controller: _heightController,
                decoration: InputDecoration(labelText: "키 (cm)"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '키를 입력해주세요.';
                  }
                  if (double.tryParse(value) == null) {
                    return '숫자만 입력 가능합니다.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),

              // 체중
              TextFormField(
                controller: _weightController,
                decoration: InputDecoration(labelText: "체중 (kg)"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '체중을 입력해주세요.';
                  }
                  if (double.tryParse(value) == null) {
                    return '숫자만 입력 가능합니다.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),

              // 생년월일: 직접 입력 대신 DatePicker 사용
              TextFormField(
                controller: _birthDateController,
                decoration: InputDecoration(labelText: "생년월일"),
                readOnly: true,
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2000),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    _birthDateController.text =
                        DateFormat('yyyy-MM-dd').format(picked);
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '생년월일을 선택해주세요.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // 다음 버튼
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(
                          name: _nameController.text,
                          gender: _selectedGender,
                          height: double.tryParse(_heightController.text) ?? 0.0,
                          weight: double.tryParse(_weightController.text) ?? 0.0,
                          birthDate: _birthDateController.text,
                        ),
                      ),
                    );
                  }
                },
                child: Text("다음"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 🟢 2. 홈 화면
class HomeScreen extends StatefulWidget {
  final String name;
  final String gender;
  final double height;
  final double weight;
  final String birthDate;

  HomeScreen({
    required this.name,
    required this.gender,
    required this.height,
    required this.weight,
    required this.birthDate,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double hrMax = 0;
  double? vo2Max;
  int? age;
  File? _profileImage;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _calculateHRmax();
  }

  void _calculateHRmax() {
    try {
      DateTime birthDate = DateFormat("yyyy-MM-dd").parse(widget.birthDate);
      int calculatedAge = DateTime.now().year - birthDate.year;

      setState(() {
        age = calculatedAge;
        hrMax = 220 - calculatedAge.toDouble();
      });
    } catch (e) {
      setState(() {
        age = null;
        hrMax = 0;
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text("카메라로 촬영"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo),
                title: Text("갤러리에서 선택"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => _showImagePickerOptions(context),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage:
                    _profileImage != null ? FileImage(_profileImage!) : null,
                    child: _profileImage == null
                        ? Icon(Icons.person, size: 40, color: Colors.white)
                        : null,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  widget.name,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("내 정보"),
            onTap: _showUserInfo,
          ),
          ListTile(
            leading: Icon(Icons.calculate),
            title: Text("계산기"),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("설정"),
            onTap: _editUserInfo,
          ),
        ],
      ),
    );
  }

  void _showUserInfo() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("내 정보"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("이름: ${widget.name}"),
              Text("성별: ${widget.gender}"),
              Text("키: ${widget.height} cm"),
              Text("체중: ${widget.weight} kg"),
              Text("HRmax: ${hrMax.toStringAsFixed(1)} bpm"),
              Text("VO2max: ${vo2Max != null ? vo2Max!.toStringAsFixed(1) : '데이터 없음'} ml/kg/min"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("닫기"),
            ),
          ],
        );
      },
    );
  }

  void _editUserInfo() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PersonalInfoScreen()),
    );
  }

  /// Hero 애니메이션을 위한 버튼 생성
  Widget _buildHeroCalculatorButton({
    required BuildContext context,
    required String title,
    required Widget destination,
    required String heroTag,
    required IconData icon,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => destination));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hero 시작점
            Hero(
              tag: heroTag,
              child: Icon(icon, size: 32, color: Colors.blue),
            ),
            SizedBox(width: 8),
            Text(title, style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("운동 생리학 계산기"),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      drawer: _buildDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // VO2max Hero
            _buildHeroCalculatorButton(
              context: context,
              title: "VO2max 계산기",
              icon: Icons.directions_run,
              heroTag: "vo2maxHero",
              destination: VO2maxCalculatorScreen(
                onCalculate: (double result) {
                  setState(() {
                    vo2Max = result;
                  });
                },
                age: age ?? 0,
                gender: widget.gender,
              ),
            ),
            // HRmax Hero
            _buildHeroCalculatorButton(
              context: context,
              title: "HRmax 계산기",
              icon: Icons.favorite_border,
              heroTag: "hrmaxHero",
              destination: HRmaxCalculatorScreen(hrMax: hrMax),
            ),
            // 메타볼릭 Hero
            _buildHeroCalculatorButton(
              context: context,
              title: "에너지 대사 기여도 분석",
              icon: Icons.pie_chart_outline,
              heroTag: "metabolicHero",
              destination: MetabolicContributionScreen(),
            ),
          ],
        ),
      ),
    );
  }
}

// 🟢 3. VO2max 계산기
class VO2maxCalculatorScreen extends StatefulWidget {
  final Function(double) onCalculate;
  final int age;
  final String gender;

  VO2maxCalculatorScreen({
    required this.onCalculate,
    required this.age,
    required this.gender,
  });

  @override
  _VO2maxCalculatorScreenState createState() => _VO2maxCalculatorScreenState();
}

class _VO2maxCalculatorScreenState extends State<VO2maxCalculatorScreen> {
  final TextEditingController _timeController = TextEditingController();
  double? _vo2max;
  String? _comparison;

  final Map<String, Map<String, double>> _averageVO2max = {
    "20-29": {"male": 42.5, "female": 35.0},
    "30-39": {"male": 40.5, "female": 33.0},
    "40-49": {"male": 38.5, "female": 30.5},
    "50-59": {"male": 35.0, "female": 28.0},
    "60+":   {"male": 30.0, "female": 25.0},
  };

  String _getAgeGroup(int age) {
    if (age < 30) {
      return "20-29";
    } else if (age < 40) {
      return "30-39";
    } else if (age < 50) {
      return "40-49";
    } else if (age < 60) {
      return "50-59";
    } else {
      return "60+";
    }
  }

  void _calculateVO2Max() {
    try {
      final inputTime = _timeController.text;
      final parts = inputTime.split(":");

      if (parts.length != 2) {
        setState(() {
          _vo2max = null;
          _comparison = "올바른 시간 형식이 아닙니다. (예: 12:30)";
        });
        return;
      }

      final minutes = int.parse(parts[0]);
      final seconds = int.parse(parts[1]);
      final totalTime = minutes + (seconds / 60.0);

      final vo2max = 483 / totalTime + 3.5;

      setState(() {
        _vo2max = vo2max;
        _comparison = _compareVO2max(vo2max);
      });

      widget.onCalculate(vo2max);
    } catch (e) {
      setState(() {
        _vo2max = null;
        _comparison = "입력 오류! 올바른 형식으로 입력하세요.";
      });
    }
  }

  String _compareVO2max(double userVO2max) {
    final genderKey = (widget.gender == "남성") ? "male" : "female";
    final ageGroup = _getAgeGroup(widget.age);

    final avgMale = _averageVO2max[ageGroup]!["male"]!;
    final avgFemale = _averageVO2max[ageGroup]!["female"]!;
    final userAvg = (genderKey == "male") ? avgMale : avgFemale;

    final resultMsg = userVO2max >= userAvg
        ? "🔥 평균 이상! 우수한 체력입니다!"
        : "⚠ 평균 이하, 더 높은 VO2max를 목표로 운동해보세요!";

    return """
✅ 연령대: $ageGroup
🏃‍♂️ 남성 평균: ${avgMale.toStringAsFixed(1)} ml/kg/min
🏃‍♀️ 여성 평균: ${avgFemale.toStringAsFixed(1)} ml/kg/min

당신의 VO2max: ${userVO2max.toStringAsFixed(1)} ml/kg/min  
$resultMsg
""";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Hero 도착점
      appBar: AppBar(
        leading: Hero(
          tag: 'vo2maxHero',
          child: Icon(Icons.directions_run),
        ),
        title: Text("VO2max 계산기"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("2.4km 달리기 걸린 시간 입력 (MM:SS)",
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            TextField(
              controller: _timeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "예: 12:30",
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateVO2Max,
              child: Text("VO2max 계산"),
            ),
            SizedBox(height: 20),
            if (_vo2max != null)
              Column(
                children: [
                  Text(
                    "예상 VO2max: ${_vo2max!.toStringAsFixed(2)} ml/kg/min",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    _comparison ?? "",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue,
                    ),
                  ),
                ],
              )
            else
              Text(
                _comparison ?? "올바른 형식으로 입력하세요 (예: 12:30)",
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}

// 🟢 4. HRmax 계산기
class HRmaxCalculatorScreen extends StatelessWidget {
  final double hrMax;

  HRmaxCalculatorScreen({required this.hrMax});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Hero 도착점
      appBar: AppBar(
        leading: Hero(
          tag: 'hrmaxHero',
          child: Icon(Icons.favorite_border),
        ),
        title: Text("HRmax 계산기"),
      ),
      body: Center(
        child: Text(
          "계산된 HRmax: ${hrMax.toStringAsFixed(1)} bpm",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

// 🟢 5. 에너지 대사 기여도 분석 화면
class MetabolicContributionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Hero 도착점
      appBar: AppBar(
        leading: Hero(
          tag: 'metabolicHero',
          child: Icon(Icons.pie_chart_outline),
        ),
        title: Text("에너지 대사 기여도 분석"),
      ),
      body: Center(child: Text("🚧 개발 중")),
    );
  }
}