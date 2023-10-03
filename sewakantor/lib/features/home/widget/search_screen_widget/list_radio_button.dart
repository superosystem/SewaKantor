import 'package:flutter/material.dart';
import 'package:sewakantor/utils/adapt_size.dart';
import 'package:sewakantor/utils/colors.dart';
import 'package:sewakantor/widgets/string_radio_button.dart';

Widget listValueButton({
  required BuildContext context,
  required ValueNotifier<String> stringOfficeTypeVal,
  required String controllerValue1,
  required String controllerValue2,
  required String controllerValue3,
}) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.only(
      left: AdaptSize.screenWidth * .016,
      right: AdaptSize.screenWidth * .016,
      top: AdaptSize.screenHeight * .016,
      bottom: AdaptSize.screenHeight * .016,
    ),
    decoration: BoxDecoration(
      color: MyColor.neutral900,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: MyColor.grayLightColor.withOpacity(.4),
          blurStyle: BlurStyle.solid,
          offset: const Offset(1, 2),
          blurRadius: 3,
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Which office do you want to choose?',
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(fontSize: AdaptSize.pixel16),
        ),
        SizedBox(
          height: AdaptSize.screenHeight * .016,
        ),

        /// coworking space radio button
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/image_assets/space_image/coworking_space.png'),
            SizedBox(
              width: AdaptSize.screenWidth * .012,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Coworking Space',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: AdaptSize.pixel16),
                ),
                Text(
                  'for 1 person only',
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontSize: AdaptSize.pixel12,
                        color: MyColor.neutral400,
                      ),
                ),
              ],
            ),
            const Spacer(),
            stringRadioButton(
              context: context,
              customRadioController: stringOfficeTypeVal,
              controlledIdValue: controllerValue1,
            ),
          ],
        ),

        SizedBox(
          height: AdaptSize.screenHeight * .016,
        ),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/image_assets/space_image/meeting_room.png'),
            SizedBox(
              width: AdaptSize.screenWidth * .012,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Meeting Room',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: AdaptSize.pixel16),
                ),
                Text(
                  'for 2-12 people only',
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontSize: AdaptSize.pixel10,
                        color: MyColor.neutral400,
                      ),
                ),
              ],
            ),
            const Spacer(),
            stringRadioButton(
              context: context,
              customRadioController: stringOfficeTypeVal,
              controlledIdValue: controllerValue2,
            ),
          ],
        ),

        SizedBox(
          height: AdaptSize.screenHeight * .016,
        ),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/image_assets/space_image/office_building.png'),
            SizedBox(
              width: AdaptSize.screenWidth * .012,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Office Building',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: AdaptSize.pixel16),
                ),
                Text(
                  'for 10-100 people only',
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontSize: AdaptSize.pixel12,
                        color: MyColor.neutral400,
                      ),
                ),
              ],
            ),
            const Spacer(),
            stringRadioButton(
              context: context,
              customRadioController: stringOfficeTypeVal,
              controlledIdValue: controllerValue3,
            ),
          ],
        ),
      ],
    ),
  );
}
