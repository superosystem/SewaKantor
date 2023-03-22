import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../routes/app_pages.dart';
import '../controllers/search_contact_controller.dart';

class SearchContactView extends GetView<SearchContactController> {
  SearchContactView({Key? key}) : super(key: key);
  late var listChats = chats(20);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          backgroundColor: Colors.blue,
          title: Text("Select Contact"),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.arrow_back),
          ),
          flexibleSpace: Padding(
            padding: const EdgeInsets.fromLTRB(40, 20, 40, 10),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: TextField(
                controller: controller.searchController,
                cursorColor: Colors.blue,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 1,
                    ),
                  ),
                  hintText: "Search new friend here..",
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 10,
                  ),
                  suffixIcon: InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {},
                    child: Icon(
                      Icons.search,
                      color: Colors.red[900],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        preferredSize: Size.fromHeight(120),
      ),
      body: listChats == 0
          ? Center(
              child: Container(
                width: Get.width * 0.7,
                height: Get.width * 0.7,
                child: Lottie.asset("assets/lottie/empty.json"),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: listChats.length,
              itemBuilder: (context, index) => listChats[index],
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
        trailing: GestureDetector(
          onTap: () => Get.toNamed(Routes.CHAT_ROOM),
          child: Chip(
            label: Text('Message'),
          ),
        ),
      ),
    );

    return listChat;
  }
}
