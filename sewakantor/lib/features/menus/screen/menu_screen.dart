import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sewakantor/features/menus/view_model/menu_view_model.dart';
import 'package:sewakantor/utils/adapt_size.dart';
import 'package:sewakantor/utils/colors.dart';

class MenuScreen extends StatefulWidget {
  final int currentIndex;

  const MenuScreen({
    Key? key,
    this.currentIndex = 0,
  }) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context.read<MenuViewModel>().backToMenu(index: widget.currentIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MenuViewModel>(builder: (context, value, child) {
      return WillPopScope(
        onWillPop: () async {
          return value.onWillPop(context);
        },
        child: Scaffold(
          extendBody: true,
          body: value.pages,
          bottomNavigationBar: _bottomNavBar(context),
        ),
      );
    });
  }

  Container _bottomNavBar(BuildContext context) {
    AdaptSize.size(context: context);
    return Container(
      margin: EdgeInsets.only(
        left: AdaptSize.screenHeight * .01,
        right: AdaptSize.screenHeight * .01,
        bottom: AdaptSize.screenHeight * .015,
      ),
      height: AdaptSize.screenWidth / 1000 * 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: MyColor.primary300,
        border: Border.all(
          color: MyColor.primary600,
        ),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Consumer<MenuViewModel>(builder: (context, value, index) {
        return BottomNavigationBar(
          backgroundColor: MyColor.transparanColor,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: MyColor.primary900,
          unselectedItemColor: MyColor.primary700,
          selectedIconTheme: IconThemeData(size: AdaptSize.pixel22),
          selectedLabelStyle: TextStyle(fontSize: AdaptSize.pixel12),
          unselectedFontSize: AdaptSize.pixel10,
          onTap: (index) {
            value.onTaped = index;
          },
          currentIndex: value.currentPage,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.calendar),
              label: 'Booking',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmarks_outlined),
              label: 'Whistlist',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              label: 'Profile',
            ),
          ],
        );
      }),
    );
  }
}
