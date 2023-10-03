import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sewakantor/utils/adapt_size.dart';
import 'package:sewakantor/utils/colors.dart';
import 'package:sewakantor/widgets/button_widget.dart';
import 'package:sewakantor/widgets/rich_text_widget.dart';

class CustomDialog {
  /// double action
  static Future doubleActionDialog({
    context,
    required String title,
    required String imageAsset,
    Function()? onTap1,
    Function()? onTap2,
  }) {
    return showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            content: Column(
              children: [
                SvgPicture.asset(
                  imageAsset,
                  height: AdaptSize.screenHeight * .035,
                  width: AdaptSize.screenWidth * .035,
                ),

                SizedBox(
                  height: AdaptSize.screenHeight * .01,
                ),

                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: AdaptSize.pixel14),
                ),
                SizedBox(
                  height: AdaptSize.screenHeight * .016,
                ),

                /// button oke
                dialogButton(
                  text: 'Yes, I Sure',
                  context: context,
                  side: BorderSide(
                    color: MyColor.neutral500,
                  ),
                  onPressed: onTap1,
                  backGroundColor: MyColor.neutral700,
                  textColor: MyColor.neutral500,
                ),

                SizedBox(
                  height: AdaptSize.pixel5,
                ),

                /// button batal keluar
                dialogButton(
                  text: 'No, not sure yet',
                  context: context,
                  onPressed: onTap2,
                  backGroundColor: MyColor.danger400,
                  textColor: MyColor.neutral900,
                ),
              ],
            ),
          );
        });
  }

  static Future singleActionDialog({
    context,
    required String imageAsset,
    required String title,
    required Function()? onPressed,
  }) {
    return showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            content: Column(
              children: [
                SvgPicture.asset(
                  imageAsset,
                  height: AdaptSize.screenHeight * .056,
                  width: AdaptSize.screenWidth * .056,
                ),
                SizedBox(
                  height: AdaptSize.screenHeight * .008,
                ),
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: AdaptSize.pixel14),
                ),
                SizedBox(
                  height: AdaptSize.screenHeight * .022,
                ),

                /// oke
                ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    //side: side,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize:
                        Size(double.infinity, AdaptSize.screenHeight * .048),
                    backgroundColor: MyColor.darkBlueColor,
                    elevation: 0,
                  ),
                  child: Text(
                    'Oke',
                    style: Theme.of(context).textTheme.button!.copyWith(
                        color: MyColor.neutral900, fontSize: AdaptSize.pixel12),
                  ),
                ),
              ],
            ),
          );
        });
  }

  static Future singleActionDialogWithoutImage({
    context,
    String? text1,
    String? text2,
    String? text3,
    required bool withTextRich,
    required String title,
    required Function()? onPressed,
  }) {
    return showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  withTextRich
                      ? richTextWidget(
                          text1: text1,
                          textStyle1: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(fontSize: AdaptSize.pixel12),
                          text2: text2,
                          textStyle2: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(fontSize: AdaptSize.pixel12),
                          text3: text3,
                          textStyle3: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(fontSize: AdaptSize.pixel12),
                        )
                      : Text(
                          title,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontSize: AdaptSize.pixel14),
                        ),
                  SizedBox(
                    height: AdaptSize.screenHeight * .022,
                  ),

                  /// oke
                  ElevatedButton(
                    onPressed: onPressed,
                    style: ElevatedButton.styleFrom(
                      //side: side,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize:
                          Size(double.infinity, AdaptSize.screenHeight * .048),
                      backgroundColor: MyColor.darkBlueColor,
                      elevation: 0,
                    ),
                    child: Text(
                      'Oke',
                      style: Theme.of(context).textTheme.button!.copyWith(
                          color: MyColor.neutral900,
                          fontSize: AdaptSize.pixel12),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  static Widget dialogButton({
    context,
    Function()? onPressed,
    Color? backGroundColor,
    BorderSide? side,
    required Color textColor,
    required String text,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        side: side,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        minimumSize: Size(double.infinity, AdaptSize.screenHeight * .048),
        backgroundColor: backGroundColor,
        elevation: 0,
      ),
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .button!
            .copyWith(color: textColor, fontSize: AdaptSize.pixel12),
      ),
    );
  }

  /// dialog remove whitlist item
  static Widget dialogRemoveWhislist({
    context,
    Function()? onPressed1,
    Function()? onPressed2,
  }) {
    return Center(
      child: Container(
        height: 120,
        width: double.infinity,
        margin: EdgeInsets.all(AdaptSize.pixel10),
        decoration: BoxDecoration(
          color: MyColor.neutral900,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  bottom: AdaptSize.pixel6,
                  top: AdaptSize.pixel6,
                  left: AdaptSize.pixel8),
              child: SizedBox(
                width: AdaptSize.screenWidth / 1.15384615385,
                child: Text(
                  "Are You Sure To Remove This Item From The Wishlist",
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(fontSize: AdaptSize.pixel14),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  bottom: AdaptSize.pixel6, right: AdaptSize.pixel8),
              child: SizedBox(
                width: AdaptSize.screenWidth / 1.15385,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    buttonWidget(
                      onPressed: onPressed1,
                      sizeheight: AdaptSize.screenWidth / 9,
                      backgroundColor: MyColor.danger400,
                      borderRadius: BorderRadius.circular(8),
                      child: Text(
                        'Cancel',
                        style: Theme.of(context).textTheme.button!.copyWith(
                              fontSize: AdaptSize.pixel12,
                              color: MyColor.neutral900,
                            ),
                      ),
                    ),
                    SizedBox(
                      width: AdaptSize.pixel8,
                    ),
                    buttonWidget(
                      onPressed: onPressed2,
                      sizeheight: AdaptSize.screenWidth / 9,
                      backgroundColor: MyColor.neutral900,
                      borderSide: BorderSide(
                        color: MyColor.neutral400,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      child: Text(
                        'Delete',
                        style: Theme.of(context).textTheme.button!.copyWith(
                              fontSize: AdaptSize.pixel12,
                              color: MyColor.neutral400,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
