import 'package:flutter/cupertino.dart';
import 'package:sewakantor/features/accounts/screen/account_screen.dart';
import 'package:sewakantor/features/home/screen/home_screen.dart';
import 'package:sewakantor/features/transactions/screen/booking_history_screen.dart';
import 'package:sewakantor/features/wishlists/screen/wishlist_screen.dart';
import 'package:sewakantor/widgets/dialog/exit_dialog.dart';

class MenuViewModel with ChangeNotifier {
  int _currentPage = 0;

  int get currentPage => _currentPage;

  final List<Widget> _pages = [
    const HomeScreen(),
    const BookingHistoryScreen(),
    const WishlistScreen(),
    const AccountScreen(),
  ];

  get pages => _pages[_currentPage];

  set onTaped(int index) {
    _currentPage = index;
    notifyListeners();
  }

  /// access menu index
  void backToMenu({
    required int index,
  }) {
    _currentPage = index;
    notifyListeners();
  }

  Future<bool> onWillPop(BuildContext context) async {
    if (_currentPage < 0) {
      _currentPage = 0;
      notifyListeners();
      return Future(() => false);
    } else {
      bool exit = await showExitDialog(context) ?? false;
      if (exit) {
        exit = true;
        notifyListeners();
      }
      return Future(() => exit);
    }
  }
}
