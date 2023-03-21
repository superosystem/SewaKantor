import 'package:get/get.dart';

import '../modules/chat_room/bindings/chat_room_binding.dart';
import '../modules/chat_room/views/chat_room_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/introduction/bindings/introduction_binding.dart';
import '../modules/introduction/views/introduction_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/search_contact/bindings/search_contact_binding.dart';
import '../modules/search_contact/views/search_contact_view.dart';
import '../modules/status/bindings/status_binding.dart';
import '../modules/status/views/status_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();
  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.INTRODUCTION,
      page: () => const IntroductionView(),
      binding: IntroductionBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.CHAT_ROOM,
      page: () => const ChatRoomView(),
      binding: ChatRoomBinding(),
    ),
    GetPage(
      name: _Paths.SEARCH_CONTACT,
      page: () => SearchContactView(),
      binding: SearchContactBinding(),
    ),
    GetPage(
      name: _Paths.STATUS,
      page: () => const StatusView(),
      binding: StatusBinding(),
    ),
  ];
}
