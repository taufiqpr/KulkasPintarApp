import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fridgeeye/app/modules/login/controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header dengan gradient
              Container(
                width: double.infinity,
                height: 220,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF80CBC4), Color(0xFF00796B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(40),
                  ),
                ),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Row(
                        children: const [
                          Icon(Icons.arrow_back_ios_new, color: Colors.black),
                          SizedBox(width: 4),
                          Text("Back", style: TextStyle(color: Colors.black)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Login Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 12,
                        spreadRadius: 4,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Welcome Back",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Ready to continue your learning journey?\nYour path is right here.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black54),
                      ),
                      const SizedBox(height: 24),

                      // Email Field
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(color: Colors.grey[700]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon:
                              Icon(Icons.email_outlined, color: Colors.teal),
                        ),
                        onChanged: (val) => controller.email.value = val,
                      ),

                      const SizedBox(height: 16),
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(color: Colors.grey[700]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon:
                              Icon(Icons.lock_outline, color: Colors.teal),
                        ),
                        onChanged: (value) => controller.password.value = value,
                      ),

                      const SizedBox(height: 24),

                      // Login Button
                      Obx(() => controller.isLoading.value
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: controller.login,
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                backgroundColor: const Color(0xFF80CBC4),
                                foregroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 50),
                              ),
                              child: const Text(
                                "Log In",
                                style: TextStyle(fontSize: 16),
                              ),
                            )),

                      const SizedBox(height: 24),

                      const Divider(),
                      const SizedBox(height: 12),

                      // Social Login
                      const Text("Sign in with"),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(FontAwesomeIcons.facebookF,
                                color: Colors.blue),
                            onPressed: () {},
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            icon: const Icon(FontAwesomeIcons.google,
                                color: Colors.red),
                            onPressed: () {
                              controller.loginWithGoogle();
                            },
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            icon: const Icon(FontAwesomeIcons.apple,
                                color: Colors.black),
                            onPressed: () {},
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      TextButton(
                        onPressed: () => Get.toNamed('/register'),
                        child: const Text.rich(
                          TextSpan(
                            text: "Don't have an account? ",
                            children: [
                              TextSpan(
                                text: "Sign Up",
                                style: TextStyle(color: Colors.purple),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
