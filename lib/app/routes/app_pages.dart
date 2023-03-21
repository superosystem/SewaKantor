import 'package:get/get.dart';

import '../modules/chat_room/bindings/chat_room_binding.dart';
import '../modules/chat_room/views/chat_room_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/introduction/bindings/introduction_binding.dart';
import '../modules/introduction/views/introduction_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/profile/change_profile/bindings/change_profile_binding.dart';
import '../modules/profile/change_profile/views/change_profile_view.dart';
import '../modules/profile/status/bindings/status_binding.dart';
import '../modules/profile/status/views/status_view.dart';
import '../modules/profile/view_profile/bindings/profile_binding.dart';
import '../modules/profile/view_profile/views/profile_view.dart';
import '../modules/search_contact/bindings/search_contact_binding.dart';
import '../modules/search_contact/views/search_contact_view.dart';

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
      children: [
        GetPage(
          name: _Paths.CHANGE_PROFILE,
          page: () => const ChangeProfileView(),
          binding: ChangeProfileBinding(),
        ),
      ],
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
