import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Activity6 extends StatefulWidget {
  const Activity6({super.key});

  @override
  State<Activity6> createState() => _Activity6State();
}

class _Activity6State extends State<Activity6> {
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
          "activity_id": 6,
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
                          Text("🍎", style: TextStyle(fontSize: 26)),
                          SizedBox(width: 10),
                          Text(
                            'සමනව බෙදන්න.',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    /// APPLES (6)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(6, (_) => _apple()),
                    ),

                    const SizedBox(height: 28),

                    /// ARROWS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.arrow_downward, size: 40),
                        SizedBox(width: 80),
                        Icon(Icons.arrow_downward, size: 40),
                      ],
                    ),

                    const SizedBox(height: 18),

                    /// BUCKETS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _bucket(),
                        const SizedBox(width: 40),
                        _bucket(),
                      ],
                    ),

                    const SizedBox(height: 26),

                    /// ANSWERS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _answerBox('6'),
                        const SizedBox(width: 16),
                        _answerBox('2'),
                        const SizedBox(width: 16),
                        _answerBox('3'), // ✅ correct
                      ],
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            /// BOTTOM AREA
            SizedBox(
              height: screenHeight * 0.34,
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
                          '/activity-7',
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
  Widget _apple() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Image.asset(
        'assests/apple1.jpeg',
        width: 50,
        height: 50,
      ),
    );
  }

  /// BUCKET
  Widget _bucket() {
    return Image.asset(
      'assests/waati.png',
      width: 120,
      height: 90,
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
