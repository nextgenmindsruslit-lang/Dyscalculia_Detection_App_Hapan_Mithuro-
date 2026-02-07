import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Activity1 extends StatefulWidget {
  const Activity1({super.key});

  @override
  State<Activity1> createState() => _Activity1State();
}

class _Activity1State extends State<Activity1> {
  late String childName;
  bool initialized = false;

  String? selectedAnswer;
  late DateTime startTime;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!initialized) {
      final args = ModalRoute.of(context)?.settings.arguments;

      childName = (args != null && args is String)
          ? args
          : "unknown_child";

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
          "activity_id": 1,
          "given_answer": selectedAnswer,
          "time_taken_seconds": timeTaken,
        }),
      );
    } catch (e) {
      debugPrint("Server not reachable");
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
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    /// QUESTION
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5DC8C),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Text(
                        'ඇපල් කොපමණ තිබේද?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// APPLES
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                _apple(),
                                const SizedBox(width: 8),
                                _apple(),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                _apple(),
                                const SizedBox(width: 8),
                                _apple(),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5DC8C),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Center(
                            child: Text(
                              '?',
                              style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                    _apple(),
                    const SizedBox(height: 24),

                    /// ANSWERS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _answerBox('5'),
                        const SizedBox(width: 16),
                        _answerBox('4'), // ✅ correct
                        const SizedBox(width: 16),
                        _answerBox('6'),
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

                  /// YAMU BUTTON
                  Align(
                    alignment: const FractionalOffset(0.85, 0.75),
                    child: GestureDetector(
                      onTap: () async {
                          // ✅ Save even if selectedAnswer == null (SKIPPED)

                        await saveResult();

                        /// ✅ PASS CHILD NAME TO ACTIVITY 2
                        Navigator.pushNamed(
                          context,
                          '/activity-2',
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

  /// APPLE
  static Widget _apple() {
    return Image.asset(
      'assests/apple1.jpeg',
      width: 55,
      height: 55,
      fit: BoxFit.contain,
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
        width: 75,
        height: 75,
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
