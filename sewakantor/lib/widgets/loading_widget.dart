import 'package:sewakantor/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingWidget {
  /// white loading color
  static Widget whiteButtonLoading = SpinKitFadingCircle(
    color: MyColor.whiteColor,
    size: 45,
  );

  static Widget darkBlueButtonLoading = SpinKitFadingCircle(
    color: MyColor.secondary400,
    size: 50,
  );
}
