import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../activities/activity10.dart';

class ViewReportDetailScreen extends StatefulWidget {
  final String childName;

  const ViewReportDetailScreen({
    super.key,
    required this.childName,
  });

  @override
  State<ViewReportDetailScreen> createState() =>
      _ViewReportDetailScreenState();
}

class _ViewReportDetailScreenState extends State<ViewReportDetailScreen> {
  bool isLoading = true;

  Map<String, dynamic>? child;
  List<dynamic> activities = [];

  String? dysRisk;
  String? attentionStatus;
  String? memoryStatus;

  bool attentionMemoryDone = false;

  @override
  void initState() {
    super.initState();
    fetchReport();
  }

  Future<void> fetchReport() async {
    try {
      final response = await http.get(
        Uri.parse(
          "http://10.0.2.2:5000/view-report/${widget.childName}",
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          child = data["child"];
          activities = data["activities"];

          dysRisk = data["dyscalculia_risk"];
          attentionStatus = data["attention_status"];
          memoryStatus = data["memory_status"];

          // ✅ Check if activities 10–13 already done
          attentionMemoryDone = activities.any(
            (a) => a["activity_id"] >= 10 && a["activity_id"] <= 13,
          );

          isLoading = false;
        });
      } else {
        throw Exception("Failed to load report");
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error loading report")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (child == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text("Report not available")),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ---------------- CHILD INFO ----------------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: const Color(0xFFFCD55C),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow("Name", child!["child_name"]),
                  _infoRow("Age", child!["age"].toString()),
                  _infoRow("Gender", child!["gender"]),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ---------------- ACTIVITY TABLE ----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Table(
                border: TableBorder.all(color: Colors.black),
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(4),
                  2: FlexColumnWidth(3),
                },
                children: [
                  _tableHeader(),
                  ...activities.map(_activityRow).toList(),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ---------------- STATUS ----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Status of Child",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),

                  _dyscalculiaStatus(),
                  const SizedBox(height: 12),
                  _attentionStatus(),
                  const SizedBox(height: 12),
                  _memoryStatus(),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ---------------- RECOMMEND BUTTON ----------------
            GestureDetector(
              onTap: () {
                // ❌ Already completed attention & memory activities
                if (attentionMemoryDone) {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Completed"),
                      content: const Text(
                        "All recommended activities have already been completed.",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("OK"),
                        ),
                      ],
                    ),
                  );
                  return;
                }

                // ❌ No dyscalculia risk
                if (dysRisk == "No Risk") {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("No Recommendation"),
                      content: const Text(
                        "Your child does not need additional activities.",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("OK"),
                        ),
                      ],
                    ),
                  );
                  return;
                }

                // ✅ Navigate to Activity 10
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const Activity10Screen(),
                    settings: RouteSettings(arguments: widget.childName),
                  ),
                );
              },
              child: _yellowButton("Recommend"),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ---------------- HELPERS ----------------

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(label, style: const TextStyle(fontSize: 20)),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  TableRow _tableHeader() {
    return TableRow(
      children: [
        _headerCell("Activity No"),
        _headerCell("Given Answer"),
        _headerCell("Result"),
      ],
    );
  }

  TableRow _activityRow(dynamic a) {
    return TableRow(
      children: [
        _cell(a["activity_id"].toString()),
        _cell(a["given_answer"] ?? "Skipped"),
        _cell(a["is_correct"] == 1 ? "Correct" : "Wrong"),
      ],
    );
  }

  Widget _cell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(text, textAlign: TextAlign.center),
    );
  }

  Widget _headerCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  // ---------------- STATUS WIDGETS ----------------

  Widget _dyscalculiaStatus() {
    if (dysRisk == "High Risk") {
      return _statusDisplay(
        Colors.red,
        "High Dyscalculia Risk\nYour child needs intervention",
      );
    }

    if (dysRisk == "Mild Risk") {
      return _statusDisplay(
        Colors.orange,
        "Mild Dyscalculia Risk\nRecommended activities",
      );
    }

    return _statusDisplay(
      Colors.green,
      "No Dyscalculia Risk\nYour child is doing well",
    );
  }

  Widget _attentionStatus() {
    if (attentionStatus == "Attention Impairment") {
      return _statusDisplay(
        Colors.red,
        "Attention Impairment Detected",
      );
    }

    return _statusDisplay(
      Colors.green,
      "Attention Level is Normal",
    );
  }

  Widget _memoryStatus() {
    if (memoryStatus == "Memory Impairment") {
      return _statusDisplay(
        Colors.red,
        "Memory Impairment Detected",
      );
    }

    return _statusDisplay(
      Colors.green,
      "Memory Skills are Normal",
    );
  }

  Widget _statusDisplay(Color color, String text) {
    return Row(
      children: [
        Container(width: 18, height: 18, color: color),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: color, fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _yellowButton(String text) {
    return Container(
      width: 220,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFDD75),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
