import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fridgeeye/app/routes/app_pages.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FridgeEye App',
      initialRoute: '/welcome',
      getPages: AppRoutes.routes,
    );
  }
}
