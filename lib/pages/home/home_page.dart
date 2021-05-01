import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:path_accesser/routes/app_pages.dart';

class HomePage extends GetView {
  final title;
  HomePage({required this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(Routes.SUB_PATH_UI);
            },
            icon: Icon(Icons.folder_open),
          ),
        ],
      ),
    );
  }
}
