import 'package:sewakantor/utils/adapt_size.dart';
import 'package:sewakantor/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationModel {
  String day, title, descriptionkey, description, image;
  Icon logo;
  Color backgroundColor;

  NotificationModel({
    required this.logo,
    required this.backgroundColor,
    required this.image,
    required this.title,
    required this.day,
    required this.description,
    required this.descriptionkey,
  });
}

class CommonDataNotification {
  static Icon bookingAccepted = Icon(
    Icons.done,
    color: MyColor.neutral900,
    size: AdaptSize.pixel14,
  );
  static Icon failed = Icon(
    Icons.close,
    color: MyColor.neutral900,
    size: AdaptSize.pixel14,
  );
  static Icon waiting = Icon(
    Icons.access_time,
    color: MyColor.neutral900,
    size: AdaptSize.pixel14,
  );
  static Icon verified = Icon(
    Icons.wallet,
    color: MyColor.neutral900,
    size: AdaptSize.pixel14,
  );
  static Icon percent = Icon(
    Icons.percent,
    color: MyColor.neutral900,
    size: AdaptSize.pixel14,
  );
  static Icon newBuilding = Icon(
    CupertinoIcons.building_2_fill,
    color: MyColor.neutral900,
    size: AdaptSize.pixel14,
  );

  static Color successColor = MyColor.success300;
  static Color pendingColor = MyColor.neutral400;
  static Color failedColor = MyColor.danger300;
  static Color percentColor = MyColor.secondary200;
  static Color newBuildingColor = MyColor.primary400;

  static String imagePromo1 = 'assets/image_assets/promo_image/promo1.png';
  static String imagePromo2 = 'assets/image_assets/promo_image/promo2.png';
  static String imagePromo3 = 'assets/image_assets/promo_image/promo3.png';
  static String imageBuilding = 'assets/image_assets/space_image/space1.png';
}
