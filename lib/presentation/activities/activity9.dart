import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dyscaculia_project/presentation/activity completion/activity_completion.dart';

class Activity9 extends StatefulWidget {
  const Activity9({super.key});

  @override
  State<Activity9> createState() => _Activity9State();
}

class _Activity9State extends State<Activity9> {
  late String childName;
  bool initialized = false;

  String? selectedAnswer;
  late DateTime startTime;

  final String correctAnswer = '-';

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
          "activity_id": 9,
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

                    /// BANNER
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 22),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5DC8C),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Text(
                        'නිවැරදි ගණිත ක්‍රියාව තෝරන්න',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// QUESTION
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Column(
                          children: List.generate(3, (_) => _strawberry()),
                        ),

                        const SizedBox(width: 12),

                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5DC8C),
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),

                        const SizedBox(width: 12),

                        const Text(
                          '1 =',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Column(
                          children: List.generate(2, (_) => _strawberry()),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    /// OPERATORS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _operatorBox('+'),
                        const SizedBox(width: 16),
                        _operatorBox('-'), // ✅ correct
                        const SizedBox(width: 16),
                        _operatorBox('×'),
                      ],
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
                        
                          await saveResult(); // save only if answered
                        

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const ActivityCompletion(),
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

  /// STRAWBERRY
  Widget _strawberry() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Image.asset(
        'assests/strawberry.png',
        width: 45,
        height: 45,
      ),
    );
  }

  /// OPERATOR BOX
  Widget _operatorBox(String symbol) {
    final isSelected = selectedAnswer == symbol;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAnswer = symbol;
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
            symbol,
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
