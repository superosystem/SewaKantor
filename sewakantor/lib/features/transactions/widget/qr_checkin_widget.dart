import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:sewakantor/utils/adapt_size.dart';
import 'package:sewakantor/utils/colors.dart';

/// dialog login success
Future<Object?> qrCodeCheckIn({
  context,
  required String title,
  required String description,
  required String qrCodeData,
}) {
  return showGeneralDialog(
      context: context,
      barrierLabel: "QR Code Check-in",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            height: AdaptSize.screenWidth / 1000 * 950,
            width: AdaptSize.screenWidth * .8,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.all(AdaptSize.pixel10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: MyColor.neutral900,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(1, 3),
                  color: MyColor.primary800,
                  blurRadius: 4,
                )
              ],
            ),
            child: Material(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: AdaptSize.pixel10,
                  ),

                  /// text title
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(fontSize: AdaptSize.pixel14),
                  ),

                  SizedBox(
                    height: AdaptSize.screenHeight * .008,
                  ),

                  /// text suggestion
                  Text(
                    description,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontSize: AdaptSize.pixel12),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),

                  Container(
                    height: AdaptSize.screenWidth / 500 * 250,
                    width: AdaptSize.screenWidth / 500 * 250,
                    margin: EdgeInsets.only(
                      top: AdaptSize.pixel20,
                      bottom: AdaptSize.screenHeight * .016,
                    ),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: MyColor.neutral900,
                      boxShadow: [
                        BoxShadow(
                            offset: const Offset(1, 2),
                            color: MyColor.primary800.withOpacity(.4),
                            blurRadius: 5),
                      ],
                    ),
                    child: BarcodeWidget(
                      data: qrCodeData,
                      barcode: Barcode.qrCode(),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.close,
                      size: AdaptSize.pixel20,
                      color: MyColor.neutral400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return FadeTransition(
          opacity: anim,
          child: child,
        );
      });
}
