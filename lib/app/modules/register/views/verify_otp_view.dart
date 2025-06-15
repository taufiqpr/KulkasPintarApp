import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fridgeeye/app/modules/register/controllers/register_controller.dart';

class VerifyOtpView extends GetView<RegisterController> {
  final TextEditingController otp1 = TextEditingController();
  final TextEditingController otp2 = TextEditingController();
  final TextEditingController otp3 = TextEditingController();
  final TextEditingController otp4 = TextEditingController();
  final TextEditingController otp5 = TextEditingController();
  final TextEditingController otp6 = TextEditingController();

  VerifyOtpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Get.back(),
              ),
              const SizedBox(height: 12),
              Center(
                child: Image.asset(
                  'assets/images/Rating.png',
                  height: 300,
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  "OTP Verification",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[800],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Column(
                  children: [
                    const Text(
                      "We will send you a one time password on this",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      controller.email.value,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:
                    [otp1, otp2, otp3, otp4, otp5, otp6].map((controller) {
                  return SizedBox(
                    width: 50,
                    child: TextField(
                      controller: controller,
                      maxLength: 1,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
              Obx(() {
                final time = controller.remainingTime.value;
                final minutes = (time ~/ 60).toString().padLeft(2, '0');
                final seconds = (time % 60).toString().padLeft(2, '0');

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : () {
                                final otp = otp1.text +
                                    otp2.text +
                                    otp3.text +
                                    otp4.text +
                                    otp5.text +
                                    otp6.text;
                                controller.verifyOtp(otp);
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal[600],
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: controller.isLoading.value
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text(
                                "Submit",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: TextButton(
                        onPressed:
                            time > 0 ? null : () => controller.resendOtp(),
                        child: Text(
                          time > 0
                              ? "Kirim ulang OTP dalam $minutes:$seconds"
                              : "Kirim ulang OTP",
                          style: TextStyle(
                            color: time > 0 ? Colors.grey : Colors.teal,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
