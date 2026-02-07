import 'dart:convert';
import 'package:dyscaculia_project/presentation/dashboard/view_report_select_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../splash_screen/splash_screen.dart';

class DashboardScreen extends StatefulWidget {
  final String userName; // email

  const DashboardScreen({super.key, required this.userName});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? selectedChild;
  List<String> children = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchChildren();
  }

  Future<void> fetchChildren() async {
    setState(() => isLoading = true);

    try {
      final response = await http.get(
        Uri.parse("http://10.0.2.2:5000/children/${widget.userName}"),
      );

      if (response.statusCode == 200) {
        setState(() {
          children = List<String>.from(jsonDecode(response.body));
        });
      }
    } catch (e) {
      debugPrint("Server error: $e");
    }

    setState(() => isLoading = false);
  }

  void logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const SplashScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          /// ---------- TOP IMAGE SECTION ----------
          SizedBox(
            height: screenHeight * 0.40,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    "assests/db.png",
                    fit: BoxFit.cover,
                  ),
                ),

                /// Icons
                Positioned(
                  top: 30,
                  right: 20,
                  child: Row(
                    children: [
                      const Icon(Icons.notifications_none, size: 30),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: logout,
                        child: const Icon(Icons.logout, size: 30),
                      ),
                    ],
                  ),
                ),

                /// Welcome text
                Positioned(
                  left: 20,
                  top: 80,
                  child: Text(
                    "Welcome back 👋",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// ---------- BOTTOM ----------
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  /// Child Dropdown
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFCD55C),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.black, width: 1.2),
                      ),
                      child: isLoading
                          ? const Padding(
                              padding: EdgeInsets.all(12),
                              child: CircularProgressIndicator(),
                            )
                          : DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                hint: const Text(
                                  "Select Child To Play",
                                  style: TextStyle(fontSize: 18),
                                ),
                                value: selectedChild,
                                items: children
                                    .map(
                                      (c) => DropdownMenuItem(
                                        value: c,
                                        child: Text(c),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (v) {
                                  setState(() => selectedChild = v);
                                },
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// Play
                  GestureDetector(
                    onTap: () {
                      if (selectedChild == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please select a child first"),
                          ),
                        );
                      } else {
                        Navigator.pushNamed(context, '/activity-1',   arguments: selectedChild,);
                      }
                    },
                    child: _yellowButton("Play"),
                  ),

                  const SizedBox(height: 15),

                  /// Add Child
                  GestureDetector(
                    onTap: () async {
                      await Navigator.pushNamed(
                        context,
                        '/add-child',
                        arguments: widget.userName,
                      );
                      fetchChildren(); // refresh after add
                    },
                    child: _yellowButton("Add Child"),
                  ),

                  const SizedBox(height: 15),

                  /// Edit Child
GestureDetector(
  onTap: () {
    if (selectedChild == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a child first")),
      );
      return;
    }

    Navigator.pushNamed(
      context,
      '/edit-child',
      arguments: selectedChild, // ✅ only child name
    );
  },
  child: _yellowButton("Edit Child"),
),


                  const SizedBox(height: 15),

                  /// View Report
                  GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewReportSelectScreen(
          parentEmail: widget.userName, // 👈 THIS is the email
        ),
      ),
    );
  },
  child: _yellowButton("View Report"),
),


                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _yellowButton(String title) {
    return Container(
      width: 180,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFCD55C),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black, width: 1.2),
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
