import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/deteksi_controller.dart';

class DeteksiView extends GetView<DeteksiController> {
  const DeteksiView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DeteksiView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'DeteksiView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
