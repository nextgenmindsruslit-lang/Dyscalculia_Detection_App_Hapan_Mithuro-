import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Activity2 extends StatefulWidget {
  const Activity2({super.key});

  @override
  State<Activity2> createState() => _Activity2State();
}

class _Activity2State extends State<Activity2> {
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
          "activity_id": 2,
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
                        'හිස්තැනට ගැලපෙන ලකුණ කුමක්ද?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// APPLES ? ORANGES
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /// LEFT APPLES (3)
                        Column(
                          children: [
                            _apple(),
                            const SizedBox(height: 10),
                            _apple(),
                            const SizedBox(height: 10),
                            _apple(),
                          ],
                        ),

                        const SizedBox(width: 20),

                        /// QUESTION MARK
                        Container(
                          width: 90,
                          height: 90,
                          margin: const EdgeInsets.only(top: 40),
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

                        const SizedBox(width: 20),

                        /// RIGHT ORANGES (4)
                        Column(
                          children: [
                            Row(
                              children: [
                                _orange(),
                                const SizedBox(width: 8),
                                _orange(),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                _orange(),
                                const SizedBox(width: 8),
                                _orange(),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    /// SYMBOL OPTIONS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _symbolBox('='),
                        const SizedBox(width: 16),
                        _symbolBox('<'), // ✅ CORRECT ANSWER
                        const SizedBox(width: 16),
                        _symbolBox('>'),
                      ],
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            /// BOTTOM AREA
            SizedBox(
              height: screenHeight * 0.39,
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

                        Navigator.pushNamed(context, '/activity-3',arguments: childName,);
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

  /// ORANGE
  static Widget _orange() {
    return Image.asset(
      'assests/orange.png',
      width: 55,
      height: 55,
      fit: BoxFit.contain,
    );
  }

  /// SYMBOL BOX
  Widget _symbolBox(String symbol) {
    final isSelected = selectedAnswer == symbol;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAnswer = symbol;
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
            symbol,
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
