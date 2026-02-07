import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../dashboard/dashboard_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  String? _emailError;
  String? _usernameError;
  String? _passwordError;

  List<String> _usernameSuggestions = [];

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  bool _isStrongPassword(String password) {
    return password.length >= 8 &&
        RegExp(r'[A-Z]').hasMatch(password) &&
        RegExp(r'[0-9]').hasMatch(password);
  }

  Future<void> _onSignUp() async {
    setState(() {
      _emailError = null;
      _usernameError = null;
      _passwordError = null;
      _usernameSuggestions.clear();
    });

    final email = _emailController.text.trim();
    final username = _usernameController.text.trim();
    final pass = _passwordController.text;
    final confirm = _confirmController.text;

    if (email.isEmpty || username.isEmpty || pass.isEmpty || confirm.isEmpty) {
      _showSnack("Please fill all fields");
      return;
    }

    if (username.length > 30) {
      _usernameError = "Username must be 30 characters or less";
      setState(() {});
      return;
    }

    if (pass != confirm) {
      _passwordError = "Passwords do not match";
      setState(() {});
      return;
    }

    if (!_isStrongPassword(pass)) {
      _passwordError =
          "Password must be at least 8 characters with a capital letter and a number";
      setState(() {});
      return;
    }

    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2:5000/signup"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "username": username,
          "password": pass,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => DashboardScreen(userName: username),
          ),
        );
      } else {
        if (data["error"] == "Username already exists") {
          _usernameError = data["error"];
          _usernameSuggestions =
              List<String>.from(data["suggestions"] ?? []);
        } else if (data["error"].toString().contains("Email")) {
          _emailError = data["error"];
        } else {
          _passwordError = data["error"];
        }
        setState(() {});
      }
    } catch (e) {
      _showSnack("Server not reachable");
    }
  }

  void _showSnack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  InputDecoration _fieldDecoration(String hint, {String? error}) {
    return InputDecoration(
      hintText: hint,
      errorText: error,
      hintStyle: const TextStyle(fontSize: 18),
      filled: true,
      fillColor: Colors.white,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.black, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.black, width: 1.6),
      ),
    );
  }

  Widget _mainButton({required String title, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFFCD55C),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.black, width: 1.2),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              "assests/home.png",
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Image.asset("assests/appname.png", height: 80),
                  const SizedBox(height: 40),

                  // Email
                  TextField(
                    controller: _emailController,
                    decoration:
                        _fieldDecoration("E mail", error: _emailError),
                  ),

                  const SizedBox(height: 18),

                  // Username
                  TextField(
                    controller: _usernameController,
                    decoration:
                        _fieldDecoration("Username", error: _usernameError),
                  ),

                  // Username suggestions
                  if (_usernameSuggestions.isNotEmpty)
                    Column(
                      children: _usernameSuggestions
                          .map(
                            (s) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  _usernameController.text = s;
                                  _usernameSuggestions.clear();
                                  _usernameError = null;
                                });
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Text(
                                  s,
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),

                  const SizedBox(height: 18),

                  // Password
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: _fieldDecoration(
                      "Password",
                      error: _passwordError,
                    ).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Confirm password
                  TextField(
                    controller: _confirmController,
                    obscureText: _obscureConfirm,
                    decoration:
                        _fieldDecoration("Confirm Password").copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(_obscureConfirm
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _obscureConfirm = !_obscureConfirm;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),
                  _mainButton(title: "Sign Up", onTap: _onSignUp),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
