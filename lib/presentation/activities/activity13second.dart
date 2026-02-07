import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dyscaculia_project/presentation/activity completion/activity_completion.dart';

class Activity13Second extends StatefulWidget {
  const Activity13Second({super.key});

  @override
  State<Activity13Second> createState() => _Activity13SecondState();
}

class _Activity13SecondState extends State<Activity13Second> {
  late String childName;
  bool initialized = false;
  late DateTime startTime;

  /// only ONE row can be selected
  int? selectedRow;

  /// correct answer → ROW 2 (index 1)
  final int correctRow = 1;

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

    String? givenAnswer;
    if (selectedRow == null) {
      givenAnswer = null; // skipped
    } else {
      givenAnswer = selectedRow.toString();
    }

    try {
      await http.post(
        Uri.parse("http://10.0.2.2:5000/save-activity"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "child_name": childName,
          "activity_id": 13,
          "given_answer": givenAnswer,
          "time_taken_seconds": timeTaken,
        }),
      );
    } catch (e) {
      debugPrint("Backend not reachable");
    }
  }

  Widget shapeRow(int rowIndex, List<Widget> shapes) {
    final bool isSelected = selectedRow == rowIndex;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRow = rowIndex;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.greenAccent
              : const Color(0xFFFFE082),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.black),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: shapes,
        ),
      ),
    );
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
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFFCD55C),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  "කලින් දිස්වු රටාව කුමක්ද?",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
            ),

            const SizedBox(height: 25),

            /// ROW 1
            shapeRow(0, [
              triangle(),
              star(),
              circle(),
              square(),
            ]),

            /// ROW 2 (✅ CORRECT)
            shapeRow(1, [
              triangle(),
              circle(),
              square(),
              star(),
            ]),

            /// ROW 3
            shapeRow(2, [
              circle(),
              triangle(),
              star(),
              square(),
            ]),

            const Spacer(),

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
                    ),
                  ),

                  /// YAMU
                  Align(
                    alignment: const FractionalOffset(0.85, 0.75),
                    child: GestureDetector(
                      onTap: () async {
                        await saveResult();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ActivityCompletion(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFC107),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.black),
                        ),
                        child: const Text(
                          "යමු",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
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
}

/// SHAPES
Widget triangle() => CustomPaint(
      size: const Size(40, 40),
      painter: _TrianglePainter(),
    );

Widget circle() => Container(
      width: 40,
      height: 40,
      decoration:
          const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
    );

Widget square() => Container(
      width: 40,
      height: 40,
      color: Colors.blue,
    );

Widget star() => const Icon(Icons.star, size: 40, color: Colors.red);

class _TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.pink;
    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
