import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sewakantor/features/home/screen/voucer_promo_screen.dart';
import 'package:sewakantor/features/promo/view_model/promo_view_model.dart';
import 'package:sewakantor/utils/adapt_size.dart';

Widget carouselWidget(context) {
  final voucerPromo = Provider.of<PromoViewModel>(context, listen: false);
  final detailPromo = voucerPromo.voucerPromo;
  return CarouselSlider.builder(
    itemCount: detailPromo.length,
    itemBuilder: (context, index, img) {
      /// next page hero animation
      return Hero(
        tag: detailPromo[index].imagePromo,
        child: Material(
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              Navigator.of(context).pushNamed(
                VoucerPromoScreen.routeName,
                arguments: detailPromo[index].id,
              );
            },
            child: Padding(
              padding: EdgeInsets.only(
                left: AdaptSize.screenWidth * .004,
                right: AdaptSize.screenWidth * .004,
              ),
              child: Image.asset(
                detailPromo[index].imagePromo,
              ),
            ),
          ),
        ),
      );
    },
    options: CarouselOptions(
      height: AdaptSize.screenWidth / 2000 * 700,
      aspectRatio: AdaptSize.screenWidth / 1000 * 150,
      viewportFraction: .72,
      autoPlay: true,
      autoPlayCurve: Curves.fastOutSlowIn,
      autoPlayInterval: const Duration(seconds: 3),
    ),
  );
}
