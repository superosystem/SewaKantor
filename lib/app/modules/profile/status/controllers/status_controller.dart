import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StatusController extends GetxController {
  late TextEditingController statusController;

  @override
  void onInit() {
    statusController = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    statusController.dispose();
    super.onClose();
  }
}
