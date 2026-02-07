import 'package:flutter/material.dart';
import 'activity13second.dart';

class Activity13 extends StatefulWidget {
  const Activity13({super.key});

  @override
  State<Activity13> createState() => _Activity13State();
}

class _Activity13State extends State<Activity13> {
  late String childName;
  bool initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!initialized) {
      childName = ModalRoute.of(context)!.settings.arguments as String;
      initialized = true;
    }
  }

  Widget shapeBox(Widget child) {
    return Container(
      width: 70,
      height: 70,
      alignment: Alignment.center,
      child: child,
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

            /// ================= TOP CONTENT =================
            Expanded(
              child: Column(
                children: [

                  const SizedBox(height: 20),

                  /// ---------- TITLE ----------
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCD55C),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        "මෙය හොඳින් මතක තබාගන්න.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 60),

                  /// ---------- SHAPES (STATIC) ----------
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 18,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE082),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        /// Triangle
                        shapeBox(
                          CustomPaint(
                            size: const Size(40, 40),
                            painter: TrianglePainter(color: Colors.pink),
                          ),
                        ),

                        /// Circle
                        shapeBox(
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),

                        /// Square
                        shapeBox(
                          Container(
                            width: 40,
                            height: 40,
                            color: Colors.blue,
                          ),
                        ),

                        /// Star
                        shapeBox(
                          const Icon(
                            Icons.star,
                            size: 44,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            /// ================= BOTTOM AREA =================
            SizedBox(
              height: screenHeight * 0.37,
              child: Stack(
                clipBehavior: Clip.none,
                children: [

                  /// ---------- BEAR ----------
                  Positioned(
                    left: -55,
                    bottom: -55,
                    child: Image.asset(
                      "assests/bear.png",
                      height: screenHeight * 0.75,
                      fit: BoxFit.contain,
                    ),
                  ),

                  /// ---------- YAMU BUTTON ----------
                  Align(
                    alignment: const FractionalOffset(0.85, 0.75),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const Activity13Second(),
                            settings: RouteSettings(
                              arguments: childName,
                            ),
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
}

/// ================= TRIANGLE PAINTER =================
class TrianglePainter extends CustomPainter {
  final Color color;
  TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
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
