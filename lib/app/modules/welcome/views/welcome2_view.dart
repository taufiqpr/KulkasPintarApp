import 'package:flutter/material.dart';
import 'package:fridgeeye/app/modules/welcome/views/welcome3_view.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class Welcome2View extends StatelessWidget {
  const Welcome2View({Key? key}) : super(key: key);

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
              Lottie.asset(
                'assets/images/RecipeFood.json',
                height: size.height * 0.60,
              ),
              Column(
                children: const [
                  Text(
                    "Recipe Recommendations\nfor Ingredients You Have Food Fresh",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Find and try recipes from all over the world\nwith ingredients you already have in your fridge.",
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
                children: const [
                  CircleAvatar(radius: 4, backgroundColor: Colors.tealAccent),
                  SizedBox(width: 6),
                  SizedBox(
                    width: 20,
                    height: 8,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                  ),
                  SizedBox(width: 6),
                  CircleAvatar(radius: 4, backgroundColor: Colors.tealAccent),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Get.offAllNamed('/login');
                    },
                    child: const Text("Skip",
                        style: TextStyle(color: Colors.black87)),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.to(() => const Welcome3View(),
                          transition:
                              Transition.rightToLeft, // animasi geser ke kiri
                          duration: const Duration(milliseconds: 400));
                    },
                    child: const Text("Next",
                        style: TextStyle(color: Colors.black87)),
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
