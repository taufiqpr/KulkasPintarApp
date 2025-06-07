import 'package:flutter/material.dart';
import 'package:fridgeeye/app/modules/welcome/views/welcome2_view.dart';
import 'package:get/get.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/images/Group 6819.png',
                height: size.height * 0.55,
              ),
              Column(
                children: const [
                  Text(
                    "Keep Your Food Fresh",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Automatically get updated by our\nfreshness checker to avoid\nthrowing food away.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 20,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const CircleAvatar(
                      radius: 4, backgroundColor: Colors.tealAccent),
                  const SizedBox(width: 6),
                  const CircleAvatar(
                      radius: 4, backgroundColor: Colors.tealAccent),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Get.offAllNamed('/login');
                    },
                    child: const Text(
                      "Skip",
                      style: TextStyle(color: Colors.black87),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.to(() => const Welcome2View(),
                          transition:
                              Transition.rightToLeft, 
                          duration: const Duration(milliseconds: 400));
                    },
                    child: const Text(
                      "Next",
                      style: TextStyle(color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
