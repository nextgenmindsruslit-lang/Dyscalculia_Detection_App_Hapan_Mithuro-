import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dyscaculia_project/presentation/dashboard/dashboard_screen.dart';

class LoginBackScreen extends StatefulWidget {
  const LoginBackScreen({super.key});

  @override
  State<LoginBackScreen> createState() => _LoginBackScreenState();
}

class _LoginBackScreenState extends State<LoginBackScreen> {
  final TextEditingController _passwordController = TextEditingController();

  String? errorText;
  bool isLocked = false;

  Future<void> loginParent() async {
    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2:5000/parent-login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "password": _passwordController.text,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const DashboardScreen(userName: "Parent"),
          ),
          (route) => false,
        );
      } else {
        setState(() {
          errorText = data["error"];
          isLocked = data["locked"] == true;
        });
      }
    } catch (e) {
      setState(() {
        errorText = "Server not reachable";
      });
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
            child: Image.asset(
              "assests/db.png",
              fit: BoxFit.cover,
            ),
          ),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                /// PASSWORD FIELD
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCD55C),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.black),
                    ),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      enabled: !isLocked,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter parent password",
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                /// ERROR MESSAGE
                if (errorText != null)
                  Text(
                    errorText!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                const SizedBox(height: 40),

                /// LOGIN BUTTON
                GestureDetector(
                  onTap: isLocked ? null : loginParent,
                  child: Container(
                    width: 160,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: isLocked
                          ? Colors.grey
                          : const Color(0xFFFCD55C),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.black),
                    ),
                    child: const Center(
                      child: Text(
                        "Log In",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
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
    );
  }
}
