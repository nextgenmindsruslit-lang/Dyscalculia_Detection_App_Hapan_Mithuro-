import 'package:flutter/material.dart';
import 'package:dyscaculia_project/presentation/auth/signup_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Background
          Positioned.fill(
            child: Image.asset(
              "assests/home.png",
              fit: BoxFit.cover,
            ),
          ),

          /// Content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 70),

              /// App name
              Image.asset(
                "assests/appname.png",
                height: 80,
              ),

              const SizedBox(height: 60),

              /// Login
              _buildMainButton(
                title: "Log In",
                onTap: () {
                  Navigator.pushNamed(context, '/login'); 
                },
              ),

              const SizedBox(height: 25),

              /// Sign up
              _buildMainButton(
                title: "Sign Up",
                onTap: () {
                    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SignupScreen()),
    );
                },
              ),

              const Spacer(),

             

              const SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainButton({
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

