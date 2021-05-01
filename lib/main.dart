import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_accesser/routes/app_pages.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      getPages: AppPages.routes,
    );
  }
}
