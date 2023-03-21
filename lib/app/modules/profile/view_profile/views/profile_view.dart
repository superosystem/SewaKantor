import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            onPressed: () => {},
            icon: Icon(Icons.logout, color: Colors.black),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            child: Column(
              children: [
                AvatarGlow(
                  endRadius: 80,
                  glowColor: Colors.black,
                  duration: Duration(seconds: 2),
                  child: Container(
                    width: 150,
                    height: 150,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(100),
                      image: DecorationImage(
                          image: AssetImage("assets/logo/noimage.png"),
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
                Text(
                  "User Name",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(
                  "User Email",
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Expanded(
            child: Container(
              child: Column(
                children: [
                  ListTile(
                    onTap: () => {},
                    leading: Icon(Icons.note_add_outlined),
                    title: Text(
                      "Update Status",
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: Icon(Icons.arrow_right),
                  ),
                  ListTile(
                    onTap: () => {},
                    leading: Icon(Icons.note_add_outlined),
                    title: Text(
                      "Change Profile",
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: Icon(Icons.arrow_right),
                  ),
                  ListTile(
                    onTap: () => {},
                    leading: Icon(Icons.note_add_outlined),
                    title: Text(
                      "Theme",
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: Text("Light"),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: context.mediaQueryPadding.bottom),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Chatto",
                  style: TextStyle(color: Colors.black54),
                ),
                Text(
                  "v1.0.0",
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
