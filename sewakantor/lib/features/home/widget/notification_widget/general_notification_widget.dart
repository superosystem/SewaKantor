import 'package:flutter/material.dart';
import 'package:sewakantor/data/dummy/general_notification_data.dart';
import 'package:sewakantor/data/model/notifications/notification_model.dart';
import 'package:sewakantor/utils/adapt_size.dart';
import 'package:sewakantor/utils/colors.dart';
import 'package:sewakantor/widgets/rich_text_widget.dart';

Widget generalWidget(BuildContext context) {
  return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: generalNotification.length,
      itemBuilder: (context, index) {
        final NotificationModel generalNotifications =
            generalNotification[index];
        return Card(
          color: MyColor.netralColor,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: EdgeInsets.all(AdaptSize.screenHeight * 0.01),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// image
                SizedBox(
                  height: AdaptSize.screenWidth / 1000 * 180,
                  width: AdaptSize.screenWidth / 1000 * 180,
                  child: Stack(
                    children: [
                      Container(
                        height: AdaptSize.screenWidth / 1000 * 170,
                        width: AdaptSize.screenWidth / 1000 * 170,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(generalNotifications.image),
                          ),
                        ),
                      ),

                      /// icon
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: AdaptSize.screenWidth / 1000 * 85,
                          width: AdaptSize.screenWidth / 1000 * 85,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: generalNotifications.backgroundColor,
                          ),
                          child: generalNotifications.logo,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  width: AdaptSize.screenHeight * .008,
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// notification title
                      Text(
                        generalNotifications.title,
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                              fontSize: AdaptSize.pixel16,
                            ),
                      ),

                      SizedBox(
                        height: AdaptSize.screenHeight * 0.008,
                      ),

                      /// notification description
                      richTextWidget(
                        text1: generalNotifications.description,
                        textStyle1:
                            Theme.of(context).textTheme.bodyText1!.copyWith(
                                  fontSize: AdaptSize.pixel14,
                                ),
                        text2: generalNotifications.descriptionkey,
                        textStyle2: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(fontSize: AdaptSize.pixel14),
                      ),

                      SizedBox(
                        height: AdaptSize.screenHeight * 0.008,
                      ),

                      Text(
                        generalNotifications.day,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              fontSize: AdaptSize.pixel14,
                              color: MyColor.neutral600,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      });
}
