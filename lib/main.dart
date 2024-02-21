import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui';
import 'service_key.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '풍덩',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF9370DB)
        ),
        useMaterial3: true,
      ),
      home: const HomePage(title: '풍덩'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _waterTemp = '';

  @override
  void initState() {
    super.initState();
    _getWaterTemp();
  }

  String getTodayDate() {
    final now = DateTime.now();
    final year = now.year;
    final month = now.month;
    final day = now.day;
    return '${year.toString().padLeft(4, '0')}${month.toString().padLeft(2, '0')}${day.toString().padLeft(2, '0')}';
  }

  void _getWaterTemp() async {
    final response = await http.get(
      Uri.parse('http://www.khoa.go.kr/api/oceangrid/tidalBuTemp/search.do?ServiceKey=$serviceKey&ObsCode=TW_0089&Date=${getTodayDate()}&ResultType=json')
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _waterTemp = data["result"]["data"][data["result"]["data"].length - 1]["water_temp"];
      });
    } else {
      // 에러 처리
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            color: Colors.black.withOpacity(0),
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/water.png'),
                ),
              ),
              child: Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: '\n\n\n지금\n경포대해수욕장은\n\n',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                      TextSpan(
                        text: '$_waterTemp°C',
                        style: const TextStyle(fontSize: 40, color: Colors.black),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      )
    );
  }
}