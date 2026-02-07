import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditChildScreen extends StatefulWidget {
  const EditChildScreen({super.key});

  @override
  State<EditChildScreen> createState() => _EditChildScreenState();
}

class _EditChildScreenState extends State<EditChildScreen> {
  late String originalChildName;

  final TextEditingController nameController = TextEditingController();

  String? selectedGender;
  String? selectedAge;
  String? selectedGrade;

  bool isLoading = true;

  final List<String> ages =
      List.generate(10, (index) => (5 + index).toString());

  final List<String> grades =
      List.generate(6, (index) => (1 + index).toString());

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    originalChildName =
        ModalRoute.of(context)!.settings.arguments as String;
    fetchChildDetails();
  }

  /// FETCH CHILD DETAILS
  Future<void> fetchChildDetails() async {
    try {
      final response = await http.get(
        Uri.parse("http://10.0.2.2:5000/child/$originalChildName"),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          nameController.text = data["name"];
          selectedAge = data["age"].toString();
          selectedGrade = data["grade"].toString();
          selectedGender = data["gender"];
          isLoading = false;
        });
      } else {
        _showError("Failed to load child details");
      }
    } catch (e) {
      _showError("Server not reachable");
    }
  }

  /// UPDATE CHILD
  Future<void> updateChild() async {
    if (nameController.text.trim().isEmpty ||
        selectedAge == null ||
        selectedGrade == null ||
        selectedGender == null) {
      _showError("All fields are required");
      return;
    }

    try {
      final response = await http.put(
        Uri.parse("http://10.0.2.2:5000/update-child"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "old_name": originalChildName,
          "name": nameController.text.trim(),
          "age": selectedAge,
          "grade": selectedGrade,
          "gender": selectedGender,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context);
      } else {
        _showError("Update failed");
      }
    } catch (e) {
      _showError("Server not reachable");
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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

          /// FORM
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  _inputField(
                    hint: "Child Name",
                    controller: nameController,
                  ),

                  const SizedBox(height: 15),

                  _dropdown(
                    hint: "Age",
                    value: selectedAge,
                    items: ages,
                    labelBuilder: (v) => "$v years",
                    onChanged: (v) => setState(() => selectedAge = v),
                  ),

                  const SizedBox(height: 15),

                  _dropdown(
                    hint: "Grade",
                    value: selectedGrade,
                    items: grades,
                    labelBuilder: (v) => "Grade $v",
                    onChanged: (v) => setState(() => selectedGrade = v),
                  ),

                  const SizedBox(height: 15),

                  _dropdown(
                    hint: "Gender",
                    value: selectedGender,
                    items: const ["Male", "Female"],
                    labelBuilder: (v) => v,
                    onChanged: (v) => setState(() => selectedGender = v),
                  ),

                  const SizedBox(height: 30),

                  GestureDetector(
                    onTap: updateChild,
                    child: _actionButton("Save Changes"),
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

  /// COMMON UI WIDGETS (CONSISTENT)

  Widget _inputField({
    required String hint,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        controller: controller,
        decoration: _decoration(hint),
      ),
    );
  }

  Widget _dropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required String Function(String) labelBuilder,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        height: 58,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFFCD55C),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.black, width: 1.2),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            hint: Text(hint, style: const TextStyle(fontSize: 18)),
            value: value,
            items: items.map((item) {
              return DropdownMenuItem<String>(
                value: item, // REAL VALUE
                child: Text(
                  labelBuilder(item), // DISPLAY LABEL
                  style: const TextStyle(fontSize: 18),
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  Widget _actionButton(String title) {
    return Container(
      width: 200,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFCD55C),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black, width: 1.2),
      ),
      child: Center(
        child: Text(
          title,
          style:
              const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  InputDecoration _decoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFFCD55C),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.black, width: 1.2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.black, width: 1.2),
      ),
    );
  }
}
