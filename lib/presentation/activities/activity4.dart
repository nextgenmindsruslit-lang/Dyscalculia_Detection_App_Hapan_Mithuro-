import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Activity4 extends StatefulWidget {
  const Activity4({super.key});

  @override
  State<Activity4> createState() => _Activity4State();
}

class _Activity4State extends State<Activity4> {
  late String childName;
  bool initialized = false;

  String? selectedAnswer;
  late DateTime startTime;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!initialized) {
      final args = ModalRoute.of(context)?.settings.arguments;
      childName = args != null ? args as String : "unknown_child";

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
          "activity_id": 4,
          "given_answer": selectedAnswer, // can be null (skipped)
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
                        'අංක රටාව හඳුනාගන්න',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// NUMBER PATTERN
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _numberBox('3'),
                        const SizedBox(width: 16),
                        _numberBox('6'),
                        const SizedBox(width: 16),
                        _numberBox('7'),
                      ],
                    ),

                    const SizedBox(height: 30),

                    /// TRUE / FALSE
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _choiceBox('ඔව්'),
                        const SizedBox(width: 40),
                        _choiceBox('නැත'), // ✅ correct
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
                          '/activity-5',
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

  /// NUMBER BOX
  static Widget _numberBox(String number) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFFF5DC8C),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          number,
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  /// CHOICE BOX (Selectable)
  Widget _choiceBox(String text) {
    final isSelected = selectedAnswer == text;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAnswer = text;
        });
      },
      child: Container(
        width: 90,
        height: 70,
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.greenAccent
              : const Color(0xFFF5DC8C),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
