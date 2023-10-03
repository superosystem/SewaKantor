import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sewakantor/core/network/network_aware.dart';
import 'package:sewakantor/core/network/no_connection_screen.dart';
import 'package:sewakantor/features/home/widget/notification_widget/general_notification_widget.dart';
import 'package:sewakantor/features/home/widget/notification_widget/recommendation_notification_widget.dart';
import 'package:sewakantor/features/navigation/view_model/navigasi_view_model.dart';
import 'package:sewakantor/src/model/data/general_notification_data.dart';
import 'package:sewakantor/src/model/data/recommen_transaction_data.dart';
import 'package:sewakantor/utils/adapt_size.dart';
import 'package:sewakantor/utils/colors.dart';
import 'package:sewakantor/widgets/default_appbar_widget.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabBarController;

  @override
  void initState() {
    super.initState();
    _tabBarController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabBarController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppbarWidget(
        contexts: context,
        leadIconFunction: () {
          context.read<NavigasiViewModel>().navigasiPop(context);
        },
        isCenterTitle: false,
        titles: 'Notification',
      ),
      body: NetworkAware(
        offlineChild: const NoConnectionScreen(),
        onlineChild: Padding(
          padding: EdgeInsets.only(
            left: AdaptSize.screenWidth * .016,
            right: AdaptSize.screenWidth * .016,
          ),
          child: Column(
            children: [
              /// tab bar
              SizedBox(
                height: AdaptSize.screenWidth / 800 * 80,
                width: double.infinity,
                child: TabBar(
                  controller: _tabBarController,
                  isScrollable: true,
                  labelStyle: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(fontSize: AdaptSize.pixel16),
                  indicatorColor: MyColor.primary400,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                  labelColor: MyColor.primary400,
                  unselectedLabelColor: MyColor.grayLightColor.withOpacity(.9),
                  tabs: [
                    tabSized(
                      sizeWidth: AdaptSize.screenWidth / 1000 * 300,
                      tab1: 'General',
                      valueTab1: generalNotification.length.toString(),
                    ),
                    tabSized(
                      sizeWidth: AdaptSize.screenWidth / 2000 * 1000,
                      tab1: 'Recommendation',
                      valueTab1: notificationRecomen.length.toString(),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: TabBarView(
                  controller: _tabBarController,
                  children: [
                    generalWidget(context),
                    recommendationNotificationWidget(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget tabSized({
    required double sizeWidth,
    required String tab1,
    required String valueTab1,
  }) {
    return SizedBox(
      width: sizeWidth,
      child: Row(
        children: [
          Tab(
            text: tab1,
          ),
          SizedBox(
            width: AdaptSize.pixel4,
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: BorderSide(
                color: MyColor.grayLightColor.withOpacity(.9),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                right: AdaptSize.screenHeight * .008,
                left: AdaptSize.screenHeight * .008,
                top: AdaptSize.screenHeight * .001,
                bottom: AdaptSize.screenHeight * .001,
              ),
              child: Tab(
                text: valueTab1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
