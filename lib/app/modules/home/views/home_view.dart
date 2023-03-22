import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);
  late var listChats = chats(20);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Material(
            elevation: 5,
            child: Container(
              margin: EdgeInsets.only(top: context.mediaQueryPadding.top),
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white10,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Chatto',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Material(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(50),
                    child: InkWell(
                      onTap: () => Get.toNamed(Routes.PROFILE),
                      borderRadius: BorderRadius.circular(50),
                      child: const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Icon(Icons.person, color: Colors.white,),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: listChats.length,
              itemBuilder: (context, index) => listChats[index],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.SEARCH_CONTACT),
        child: const Icon(Icons.message),
      ),
    );
  }

  List<Widget> chats(int count) {
    List<Widget> listChat = List.generate(
      count,
      (index) => ListTile(
        onTap: () => Get.toNamed(Routes.CHAT_ROOM),
        leading: CircleAvatar(
          backgroundColor: Colors.black26,
          radius: 28,
          child: Image.asset(
            'assets/logo/noimage.png',
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          'Orang ke ${index + 1}',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          "Chat orang ke ${index + 1}",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        trailing: Chip(
          label: Text('3'),
        ),
      ),
    ).reversed.toList();

    return listChat;
  }
}
