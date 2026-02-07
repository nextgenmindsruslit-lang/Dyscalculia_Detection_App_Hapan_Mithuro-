import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Activity7 extends StatefulWidget {
  const Activity7({super.key});

  @override
  State<Activity7> createState() => _Activity7State();
}

class _Activity7State extends State<Activity7> {
  late String childName;
  bool initialized = false;

  String? selectedAnswer;
  late DateTime startTime;

  final String correctAnswer = '1';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!initialized) {
      childName = ModalRoute.of(context)!.settings.arguments as String;
      startTime = DateTime.now();
      initialized = true;
    }
  }

  /// SAVE RESULT
  Future<void> saveResult() async {
    final timeTaken =
        DateTime.now().difference(startTime).inSeconds;

    try {
      await http.post(
        Uri.parse("http://10.0.2.2:5000/save-activity"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "child_name": childName,
          "activity_id": 7,
          "given_answer": selectedAnswer,
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

            /// TOP CONTENT
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text("🍊", style: TextStyle(fontSize: 26)),
                          SizedBox(width: 10),
                          Text(
                            'අඩු කරන්න.',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// TOP ORANGES
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(4, (_) => _orange()),
                    ),

                    const SizedBox(height: 12),

                    /// MINUS
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5DC8C),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Center(
                        child: Text(
                          '-',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// BOTTOM ORANGES
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (_) => _orange()),
                    ),

                    const SizedBox(height: 30),

                    /// ANSWERS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _answerBox('7'),
                        const SizedBox(width: 16),
                        _answerBox('1'), // ✅ correct
                        const SizedBox(width: 16),
                        _answerBox('2'),
                      ],
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            /// BOTTOM AREA
            SizedBox(
              height: screenHeight * 0.35,
              child: Stack(
                clipBehavior: Clip.none,
                children: [

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
                          '/activity-8',
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

  /// ORANGE
  Widget _orange() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Image.asset(
        'assests/orange.png',
        width: 55,
        height: 55,
      ),
    );
  }

  /// ANSWER BOX
  Widget _answerBox(String number) {
    final isSelected = selectedAnswer == number;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAnswer = number;
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
            number,
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
