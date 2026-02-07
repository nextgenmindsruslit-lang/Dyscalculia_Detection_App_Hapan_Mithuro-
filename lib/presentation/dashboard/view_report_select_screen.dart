import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'view_report_detail_screen.dart';

class ViewReportSelectScreen extends StatefulWidget {
  final String parentEmail;

  const ViewReportSelectScreen({
    super.key,
    required this.parentEmail,
  });

  @override
  State<ViewReportSelectScreen> createState() =>
      _ViewReportSelectScreenState();
}

class _ViewReportSelectScreenState extends State<ViewReportSelectScreen> {
  String? selectedChild;
  List<String> children = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchChildren();
  }

  Future<void> fetchChildren() async {
    try {

      final encodedEmail = Uri.encodeComponent(widget.parentEmail);

final response = await http.get(
  Uri.parse(
    "http://10.0.2.2:5000/children/$encodedEmail",
  ),
);


      if (response.statusCode == 200) {
        setState(() {
          children = List<String>.from(jsonDecode(response.body));
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load children");
      }
    } catch (e) {
      isLoading = false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error loading children")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          /// TOP IMAGE
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
                Positioned(
                  top: 30,
                  left: 20,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, size: 30),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),

          /// CONTENT
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 30),

                /// DROPDOWN
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Container(
                    height: 58,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCD55C),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.black, width: 1.2),
                    ),
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              hint: const Text(
                                "Select Child Name",
                                style: TextStyle(fontSize: 18),
                              ),
                              value: selectedChild,
                              items: children
                                  .map(
                                    (child) => DropdownMenuItem(
                                      value: child,
                                      child: Text(
                                        child,
                                        style:
                                            const TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedChild = value;
                                });
                              },
                            ),
                          ),
                  ),
                ),

                const Spacer(),

                /// VIEW REPORT BUTTON
                GestureDetector(
                  onTap: () {
                    if (selectedChild == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please select a child"),
                        ),
                      );
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ViewReportDetailScreen(
                          childName: selectedChild!, // ✅ FIX HERE
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 200,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCD55C),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.black, width: 1.2),
                    ),
                    child: const Center(
                      child: Text(
                        "View Report",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
