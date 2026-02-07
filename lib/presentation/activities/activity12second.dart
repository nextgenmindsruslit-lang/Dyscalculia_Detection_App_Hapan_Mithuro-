import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'activity13.dart';

class Activity12Second extends StatefulWidget {
  const Activity12Second({super.key});

  @override
  State<Activity12Second> createState() => _Activity12SecondState();
}

class _Activity12SecondState extends State<Activity12Second> {
  late String childName;
  bool initialized = false;
  late DateTime startTime;

  /// only ONE selection allowed
  int? selectedIndex;

  /// correct answer → GREEN 9 (index 3)
  final int correctIndex = 3;

  final List<Map<String, dynamic>> numbers = [
    {"value": "9", "color": Colors.blue},
    {"value": "9", "color": Colors.red},
    {"value": "9", "color": Colors.black},
    {"value": "9", "color": Colors.green}, // ✅ correct
    {"value": "9", "color": Colors.pink},
    {"value": "9", "color": Colors.purple},
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!initialized) {
      childName = ModalRoute.of(context)!.settings.arguments as String;
      startTime = DateTime.now();
      initialized = true;
    }
  }

  /// SAVE RESULT (correct / wrong / skipped)
  Future<void> saveResult() async {
    final timeTaken =
        DateTime.now().difference(startTime).inSeconds;

    String? givenAnswer;

    if (selectedIndex == null) {
      givenAnswer = null; // skipped
    } else {
      givenAnswer = selectedIndex.toString();
    }

    try {
      await http.post(
        Uri.parse("http://10.0.2.2:5000/save-activity"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "child_name": childName,
          "activity_id": 12,
          "given_answer": givenAnswer,
          "time_taken_seconds": timeTaken,
        }),
      );
    } catch (e) {
      debugPrint("Backend not reachable");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [

            /// TOP CONTENT
            Expanded(
              child: Column(
                children: [

                  const SizedBox(height: 20),

                  /// QUESTION
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCD55C),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        "කලින් දුන්න අංකය කුමක්ද?",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// NUMBER GRID
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _numberBox(0),
                            _numberBox(1),
                            _numberBox(2),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _numberBox(3),
                            _numberBox(4),
                            _numberBox(5),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            /// BOTTOM AREA
            SizedBox(
              height: screenHeight * 0.37,
              child: Stack(
                clipBehavior: Clip.none,
                children: [

                  /// BEAR
                  Positioned(
                    left: -55,
                    bottom: -55,
                    child: Image.asset(
                      "assests/bear.png",
                      height: screenHeight * 0.75,
                      fit: BoxFit.contain,
                    ),
                  ),

                  /// YAMU BUTTON
                  Align(
                    alignment: const FractionalOffset(0.85, 0.75),
                    child: GestureDetector(
                      onTap: () async {
                        await saveResult();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const Activity13(),
                            settings: RouteSettings(arguments: childName),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFC107),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.black),
                        ),
                        child: const Text(
                          "යමු",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// NUMBER BOX (single select → green)
  Widget _numberBox(int index) {
    final isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.greenAccent
              : const Color(0xFFFFE082),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black),
        ),
        child: Center(
          child: Text(
            numbers[index]["value"],
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: numbers[index]["color"],
            ),
          ),
        ),
      ),
    );
  }
}
