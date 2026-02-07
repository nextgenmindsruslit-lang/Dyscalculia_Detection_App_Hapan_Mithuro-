import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Activity10Screen extends StatefulWidget {
  const Activity10Screen({super.key});

  @override
  State<Activity10Screen> createState() => _Activity10ScreenState();
}

class _Activity10ScreenState extends State<Activity10Screen> {
  late String childName;
  bool initialized = false;
  late DateTime startTime;

  /// index-based selection
  List<int> selectedIndexes = [];

  /// correct = TWO red 3s (index 0 and 8)
  final List<int> correctIndexes = [0, 8];

  final List<Map<String, dynamic>> numbers = [
    {"value": "3", "color": Colors.red},        // index 0 ✅
    {"value": "8", "color": Color(0xFFFF4FC3)},
    {"value": "4", "color": Colors.black},
    {"value": "1", "color": Colors.green},
    {"value": "2", "color": Colors.blue},
    {"value": "6", "color": Colors.red},
    {"value": "3", "color": Color(0xFFFF4FC3)},
    {"value": "0", "color": Colors.blue},
    {"value": "3", "color": Colors.red},        // index 8 ✅
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

    if (selectedIndexes.isEmpty) {
      givenAnswer = null; // skipped
    } else {
      givenAnswer = selectedIndexes.join(",");
    }

    try {
      await http.post(
        Uri.parse("http://10.0.2.2:5000/save-activity"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "child_name": childName,
          "activity_id": 10,
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
              child: SingleChildScrollView(
                child: Column(
                  children: [

                    const SizedBox(height: 20),

                    /// TITLE
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFCD55C),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          "රතු පාට තුන අංකය තෝරන්න.",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// NUMBER GRID (UI SAME)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 3,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        children: List.generate(numbers.length, (index) {
                          return _numberBox(
                            index,
                            numbers[index]["value"],
                            numbers[index]["color"],
                          );
                        }),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
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
                      'assests/bear.png',
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
                          '/activity-11',
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
          ],
        ),
      ),
    );
  }

  /// NUMBER BOX (clickable → green)
  Widget _numberBox(int index, String number, Color textColor) {
    final isSelected = selectedIndexes.contains(index);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedIndexes.remove(index);
          } else {
            selectedIndexes.add(index);
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.greenAccent
              : const Color(0xFFFCD55C),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black),
        ),
        child: Center(
          child: Text(
            number,
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
