import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/change_profile_controller.dart';

class ChangeProfileView extends GetView<ChangeProfileController> {
  const ChangeProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Profile'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => Get.back,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            AvatarGlow(
              endRadius: 80,
              glowColor: Colors.black,
              duration: Duration(seconds: 2),
              child: Container(
                width: 125.0,
                height: 125.0,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(70),
                  image: DecorationImage(
                      image: AssetImage("assets/logo/noimage.png"),
                      fit: BoxFit.cover),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: controller.emailController,
              decoration: InputDecoration(
                  label: Text("Email"),
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
            ),
            SizedBox(height: 10),
            TextField(
              controller: controller.nameController,
              decoration: InputDecoration(
                  label: Text("Name"),
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
            ),
            SizedBox(height: 10),
            TextField(
              controller: controller.statusController,
              decoration: InputDecoration(
                  label: Text("Status"),
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("No Image"),
                TextButton(
                  onPressed: () => {},
                  child: Text(
                    "Select...",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            Container(
                width: Get.width,
                child: ElevatedButton(
                    onPressed: () => {},
                    child: Text(
                      "Update",
                      style: TextStyle(color: Colors.white),
                    )))
          ],
        ),
      ),
    );
  }
}
