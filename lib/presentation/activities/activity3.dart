import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Activity3 extends StatefulWidget {
  const Activity3({super.key});

  @override
  State<Activity3> createState() => _Activity3State();
}

class _Activity3State extends State<Activity3> {
  late String childName;
  bool initialized = false;

  String? selectedAnswer;
  late DateTime startTime;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!initialized) {
      childName = ModalRoute.of(context)!.settings.arguments as String;
      startTime = DateTime.now();
      initialized = true;
    }
  }

  /// SAVE RESULT TO BACKEND
  Future<void> saveResult() async {
    final timeTaken =
        DateTime.now().difference(startTime).inSeconds;

    try {
      await http.post(
        Uri.parse("http://10.0.2.2:5000/save-activity"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "child_name": childName,
          "activity_id": 3,
          "given_answer": selectedAnswer,
          "time_taken_seconds": timeTaken,
          "is_completed": 1,
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

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [

            /// MAIN CONTENT
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [

                    const SizedBox(height: 10),

                    /// QUESTION
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 22),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5DC8C),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Text(
                        'ගැලපෙන අංකය කුමක්ද?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// NUMBER GRID
                    Column(
                      children: [
                        _numberRow(['4', '5', '6']),
                        const SizedBox(height: 16),
                        _numberRow(['?', '8', '9']),
                        const SizedBox(height: 16),
                        _numberRow(['3', '7', '2'], isAnswerRow: true),
                      ],
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            /// BOTTOM AREA
            SizedBox(
              height: screenHeight * 0.41,
              child: Stack(
                clipBehavior: Clip.none,
                children: [

                  Positioned(
                    left: -55,
                    bottom: -55,
                    child: Image.asset(
                      "assests/bear.png",
                      height: screenHeight * 0.75,
                      fit: BoxFit.contain,
                    ),
                  ),

                  /// NEXT BUTTON
                  Align(
                    alignment: const FractionalOffset(0.85, 0.75),
                    child: GestureDetector(
                      onTap: () async {
                        await saveResult();
                        Navigator.pushNamed(
                          context,
                          '/activity-4',
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
                          'යමු',
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

  /// NUMBER ROW
  Widget _numberRow(List<String> numbers, {bool isAnswerRow = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: numbers.map((value) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: isAnswerRow
              ? _answerBox(value)
              : _numberBox(value),
        );
      }).toList(),
    );
  }

  /// STATIC NUMBER BOX
  static Widget _numberBox(String value) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFFF5DC8C),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: Text(
          value,
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  /// ANSWER BOX (SELECTABLE)
  Widget _answerBox(String value) {
    final isSelected = selectedAnswer == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAnswer = value;
        });
      },
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.greenAccent
              : const Color(0xFFF5DC8C),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text(
            value,
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
