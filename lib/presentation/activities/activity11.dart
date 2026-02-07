import 'package:flutter/material.dart';

class Activity11Screen extends StatefulWidget {
  const Activity11Screen({super.key});

  @override
  State<Activity11Screen> createState() => _Activity11ScreenState();
}

class _Activity11ScreenState extends State<Activity11Screen> {
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
              child: SingleChildScrollView(
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
                          "අංක දෙස හොඳින් බලන්න.",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// ---------- NUMBER GRID (NOT CLICKABLE) ----------
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 3,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        children: const [
                          _NumberBox("0", Colors.red),
                          _NumberBox("8", Color(0xFFFF4FC3)),
                          _NumberBox("7", Colors.blue),

                          _NumberBox("7", Colors.green),
                          _NumberBox("8", Colors.blue),
                          _NumberBox("6", Colors.red),

                          _NumberBox("5", Color(0xFFFF4FC3)),
                          _NumberBox("0", Colors.green),
                          _NumberBox("7", Colors.red),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
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
                      'assests/bear.png',
                      height: screenHeight * 0.75,
                      fit: BoxFit.contain,
                    ),
                  ),

                  /// ---------- YAMU BUTTON ----------
                  Align(
                    alignment: const FractionalOffset(0.85, 0.75),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/activity-11-second',
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
}

/// ================= NUMBER BOX (STATIC) =================
class _NumberBox extends StatelessWidget {
  final String number;
  final Color color;

  const _NumberBox(this.number, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFCD55C),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black),
      ),
      child: Center(
        child: Text(
          number,
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }
}
