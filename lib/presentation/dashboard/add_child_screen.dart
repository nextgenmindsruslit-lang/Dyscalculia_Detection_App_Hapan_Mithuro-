import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddChildScreen extends StatefulWidget {
  const AddChildScreen({super.key});

  @override
  State<AddChildScreen> createState() => _AddChildScreenState();
}

class _AddChildScreenState extends State<AddChildScreen> {
  final TextEditingController nameController = TextEditingController();

  String? selectedGender;
  int? selectedAge;
  int? selectedGrade;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final email = ModalRoute.of(context)!.settings.arguments as String;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          /// ---------- TOP IMAGE ----------
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

          /// ---------- FORM ----------
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 25),

                  _inputField(
                    hint: "Name of Child",
                    controller: nameController,
                  ),

                  const SizedBox(height: 15),

                  _dropdownBox<String>(
                    hint: "Gender of Child",
                    value: selectedGender,
                    items: const ["Male", "Female"],
                    onChanged: (v) => setState(() => selectedGender = v),
                  ),

                  const SizedBox(height: 15),

                  _dropdownBox<int>(
                    hint: "Age of Child",
                    value: selectedAge,
                    items: const [6, 7, 8, 9, 10],
                    onChanged: (v) => setState(() => selectedAge = v),
                  ),

                  const SizedBox(height: 15),

                  _dropdownBox<int>(
                    hint: "Grade",
                    value: selectedGrade,
                    items: const [1, 2, 3, 4, 5],
                    onChanged: (v) => setState(() => selectedGrade = v),
                  ),

                  const SizedBox(height: 30),

                  /// ---------- ADD CHILD BUTTON ----------
                  GestureDetector(
                    onTap: isLoading ? null : () => addChild(email),
                    child: Container(
                      width: 200,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFCD55C),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.black, width: 1.2),
                      ),
                      child: Center(
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.black,
                              )
                            : const Text(
                                "Add Child",
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
          ),
        ],
      ),
    );
  }

  /// ---------- TEXT INPUT ----------
  Widget _inputField({
    required String hint,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
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
        ),
      ),
    );
  }

  /// ---------- DROPDOWN BOX ----------
  Widget _dropdownBox<T>({
    required String hint,
    required T? value,
    required List<T> items,
    required Function(T?) onChanged,
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
          child: DropdownButton<T>(
            isExpanded: true,
            hint: Text(
              hint,
              style: const TextStyle(fontSize: 18),
            ),
            value: value,
            items: items
                .map(
                  (e) => DropdownMenuItem<T>(
                    value: e,
                    child: Text(
                      e.toString(),
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                )
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  /// ---------- API CALL ----------
  Future<void> addChild(String email) async {
    if (nameController.text.isEmpty ||
        selectedGender == null ||
        selectedAge == null ||
        selectedGrade == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields required")),
      );
      return;
    }

    setState(() => isLoading = true);

    final response = await http.post(
      Uri.parse("http://10.0.2.2:5000/add-child"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "name": nameController.text.trim(),
        "gender": selectedGender,
        "age": selectedAge,
        "grade": selectedGrade,
      }),
    );

    setState(() => isLoading = false);

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Child added successfully")),
      );
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context);
      });
    } else {
      final msg = jsonDecode(response.body)["error"];
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(msg)));
    }
  }
}
