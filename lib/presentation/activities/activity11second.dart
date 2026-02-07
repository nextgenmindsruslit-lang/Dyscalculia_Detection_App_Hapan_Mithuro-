import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Activity11Second extends StatefulWidget {
  const Activity11Second({super.key});

  @override
  State<Activity11Second> createState() => _Activity11SecondState();
}

class _Activity11SecondState extends State<Activity11Second> {
  late String childName;
  bool initialized = false;
  late DateTime startTime;

  /// Only ONE answer selectable
  int? selectedIndex;

  /// Correct answer = "1" (index 2)
  final int correctIndex = 2;

  final List<String> answers = ["3", "2", "1"];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!initialized) {
      final args = ModalRoute.of(context)?.settings.arguments;
      childName = args is String ? args : "";
      startTime = DateTime.now();
      initialized = true;
    }
  }

  /// SAVE RESULT
  Future<void> saveResult() async {
    final timeTaken =
        DateTime.now().difference(startTime).inSeconds;

    String? givenAnswer;

    if (selectedIndex == null) {
      givenAnswer = null; // skipped
    } else {
      givenAnswer = answers[selectedIndex!];
    }

    try {
      await http.post(
        Uri.parse("http://10.0.2.2:5000/save-activity"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "child_name": childName,
          "activity_id": 11,
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

            const SizedBox(height: 20),

            /// QUESTION
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 12,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFFCD55C),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  "නිල් පාට 7 අංකය තියෙනවද?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            /// ANSWER OPTIONS
            Expanded(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(answers.length, (index) {
                    return _answerBox(index, answers[index]);
                  }),
                ),
              ),
            ),

            /// BOTTOM AREA
            SizedBox(
              height: screenHeight * 0.45,
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

                        Navigator.pushNamed(
                          context,
                          '/activity-12',
                          arguments: childName,
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

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// ANSWER BOX (clickable → green)
  Widget _answerBox(int index, String text) {
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
              : const Color(0xFFFCD55C),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
