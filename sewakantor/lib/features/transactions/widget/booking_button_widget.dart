import 'package:flutter/material.dart';
import 'package:sewakantor/utils/adapt_size.dart';
import 'package:sewakantor/utils/colors.dart';
import 'package:sewakantor/widgets/button_widget.dart';

class BookingButtonWidget {
  /// button already / success booking button ini juga digunakan di add review
  static avaliableButton({
    context,
    Function()? onPressed,
    required String buttonText,
    required double paddingTop,
    required double paddingBottom,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        top: paddingTop,
        bottom: paddingBottom,
        right: AdaptSize.screenWidth / 48,
        left: AdaptSize.screenWidth / 48,
      ),
      child: buttonWidget(
        onPressed: onPressed ?? () {},
        borderRadius: BorderRadius.circular(10),
        sizeWidth: double.infinity,
        sizeheight: AdaptSize.pixel40,
        borderSide: BorderSide(
          width: 2,
          color: MyColor.secondary400,
        ),
        elevation: 0,
        backgroundColor: MyColor.neutral900,
        child: Text(
          buttonText,
          style: Theme.of(context).textTheme.button!.copyWith(
                color: MyColor.secondary400,
                fontSize: AdaptSize.pixel12,
              ),
        ),
      ),
    );
  }

  /// button disable status on process / cancelled
  static disableButton({
    context,
    required double paddingBottom,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        top: AdaptSize.pixel16,
        bottom: paddingBottom,
        right: AdaptSize.screenWidth / 48,
        left: AdaptSize.screenWidth / 48,
      ),
      child: buttonWidget(
        onPressed: () {},
        borderRadius: BorderRadius.circular(10),
        sizeWidth: double.infinity,
        sizeheight: AdaptSize.pixel40,
        elevation: 0,
        backgroundColor: MyColor.neutral600,
        child: Text(
          "Check-in Now",
          style: Theme.of(context).textTheme.button!.copyWith(
                color: MyColor.neutral700,
                fontSize: AdaptSize.pixel12,
              ),
        ),
      ),
    );
  }

  /// button check in di halaman detail order apabiila status sukses
  static checkinDetailOrderButton({
    context,
    Function()? onPressed,
    required String buttonText,
    required double paddingTop,
    required double paddingBottom,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        top: paddingTop,
        bottom: paddingBottom,
        right: AdaptSize.screenWidth / 48,
        left: AdaptSize.screenWidth / 48,
      ),
      child: buttonWidget(
        onPressed: onPressed,
        borderRadius: BorderRadius.circular(10),
        sizeWidth: double.infinity,
        sizeheight: AdaptSize.pixel40,
        elevation: 0,
        backgroundColor: MyColor.secondary400,
        child: Text(
          buttonText,
          style: Theme.of(context).textTheme.button!.copyWith(
                color: MyColor.neutral900,
                fontSize: AdaptSize.pixel12,
              ),
        ),
      ),
    );
  }
}
