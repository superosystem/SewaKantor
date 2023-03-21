import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatRoomController extends GetxController {
  late FocusNode focusNode;
  late TextEditingController message;
  var isShowEmoji = false.obs;

  @override
  void onInit() {
    message = TextEditingController();
    focusNode = FocusNode();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        isShowEmoji.value = false;
      }
    });
    super.onInit();
  }

  @override
  void onClose() {
    message.dispose();
    focusNode.dispose();
    super.onClose();
  }

  void addEmojiToChat(Emoji emoji) {
    message.text = message.text + emoji.emoji;
  }

  void removeEmojiFromChat() {
    message.text = message.text.substring(0, message.text.length - 2);
  }
}
