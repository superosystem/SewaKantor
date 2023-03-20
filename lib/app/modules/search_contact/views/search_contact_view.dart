import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/search_contact_controller.dart';

class SearchContactView extends GetView<SearchContactController> {
  const SearchContactView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SearchContactView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'SearchContactView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
