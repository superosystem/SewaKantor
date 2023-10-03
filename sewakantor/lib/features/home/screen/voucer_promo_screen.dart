import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sewakantor/core/network/network_aware.dart';
import 'package:sewakantor/core/network/no_connection_screen.dart';
import 'package:sewakantor/features/home/widget/voucer_promo_widget/text_table_content.dart';
import 'package:sewakantor/features/navigation/view_model/navigasi_view_model.dart';
import 'package:sewakantor/features/promo/view_model/promo_view_model.dart';
import 'package:sewakantor/utils/adapt_size.dart';
import 'package:sewakantor/utils/colors.dart';
import 'package:sewakantor/widgets/bottom_sheed_widget.dart';
import 'package:sewakantor/widgets/default_appbar_widget.dart';
import 'package:sewakantor/widgets/divider_widget.dart';

class VoucerPromoScreen extends StatelessWidget {
  static var routeName = '/voucerPromoScreen';

  const VoucerPromoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final detailVoucer = ModalRoute.of(context)?.settings.arguments as String;
    final voucerPromo = Provider.of<PromoViewModel>(context, listen: false)
        .findById(detailVoucer);
    final menuPromo = Provider.of<PromoViewModel>(context, listen: false);
    return Scaffold(
      appBar: defaultAppbarWidget(
          contexts: context,
          leadIconFunction: () {
            context.read<NavigasiViewModel>().navigasiPop(context);
          },
          isCenterTitle: false,
          titles: 'Voucer Promo'),
      body: NetworkAware(
        offlineChild: const NoConnectionScreen(),
        onlineChild: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(
            left: AdaptSize.screenWidth * .016,
            right: AdaptSize.screenWidth * .016,
            top: AdaptSize.screenWidth * .016,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// hero animation
              Hero(
                tag: voucerPromo.imagePromo,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: AdaptSize.screenHeight * .018,
                    bottom: AdaptSize.pixel16,
                  ),
                  child: Image.asset(
                    voucerPromo.imagePromo,
                  ),
                ),
              ),

              /// title promo
              Text(
                voucerPromo.title,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(fontSize: AdaptSize.pixel16),
              ),

              SizedBox(
                height: AdaptSize.pixel16,
              ),

              /// vaoucer code
              Container(
                height: AdaptSize.screenHeight / 1000 * 90,
                width: double.infinity,
                margin: EdgeInsets.only(bottom: AdaptSize.screenHeight * .008),
                padding: EdgeInsets.all(AdaptSize.screenHeight * .018),
                decoration: BoxDecoration(
                  color: MyColor.secondary950,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: MyColor.secondary700,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      voucerPromo.voucerCode,
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            fontSize: AdaptSize.pixel16,
                            color: MyColor.secondary200,
                          ),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      splashRadius: 1,
                      onPressed: () {
                        context
                            .read<PromoViewModel>()
                            .changeCopyText(context, voucerPromo.voucerCode);
                      },
                      icon: Icon(
                        Icons.copy,
                        size: AdaptSize.pixel24,
                      ),
                    ),
                  ],
                ),
              ),

              ///berlaku hingga
              Row(
                children: [
                  Text(
                    'Valid until ',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(fontSize: AdaptSize.pixel12),
                  ),
                  SizedBox(
                    width: AdaptSize.screenWidth * .008,
                  ),
                  Text(
                    voucerPromo.expDate,
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(fontSize: AdaptSize.pixel12),
                  )
                ],
              ),

              SizedBox(
                height: AdaptSize.pixel16,
              ),

              Text(
                'Other',
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(fontSize: AdaptSize.pixel16),
              ),

              SizedBox(
                height: AdaptSize.pixel16,
              ),

              SizedBox(
                width: double.infinity,
                height: AdaptSize.screenHeight * .25,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: menuPromo.voucerPromo.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              if (index == 0) {
                                /// term and condition
                                modalBottomSheed(
                                  context,
                                  textTableContent(
                                    text1: voucerPromo.termCondition1,
                                    text2: voucerPromo.termCondition2,
                                    text3: voucerPromo.termCondition3,
                                    text4: voucerPromo.termCondition4,
                                    text5: voucerPromo.termCondition5,
                                    t5: true,
                                    withDivider: true,
                                    bottomDivider: false,
                                    titleTextStyle: Theme.of(context)
                                        .textTheme
                                        .headline6!
                                        .copyWith(fontSize: AdaptSize.pixel16),
                                    contentTextStyle: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(
                                          fontSize: AdaptSize.pixel14,
                                        ),
                                  ),
                                );
                              } else if (index == 1) {
                                /// how to
                                modalBottomSheed(
                                  context,
                                  textTableContent(
                                    text1: voucerPromo.howToUse1,
                                    text2: voucerPromo.howToUse2,
                                    text3: voucerPromo.howToUse3,
                                    text4: voucerPromo.howToUse4,
                                    t5: false,
                                    withDivider: true,
                                    bottomDivider: false,
                                    titleTextStyle: Theme.of(context)
                                        .textTheme
                                        .headline6!
                                        .copyWith(fontSize: AdaptSize.pixel16),
                                    contentTextStyle: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(
                                          fontSize: AdaptSize.pixel14,
                                        ),
                                  ),
                                );
                              } else if (index == 2) {
                                /// description
                                modalBottomSheed(
                                  context,
                                  descriptionsWidget(
                                      context, voucerPromo.promoDescription),
                                );
                              }
                            },
                            splashColor: MyColor.neutral900,
                            child: Row(
                              children: [
                                menuPromo.promoMenu[index][0],
                                SizedBox(
                                  width: AdaptSize.screenWidth * .016,
                                ),
                                Text(
                                  menuPromo.promoMenu[index][1],
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                        fontSize: AdaptSize.pixel14,
                                      ),
                                ),
                                const Spacer(),
                                menuPromo.promoMenu[index][2],
                              ],
                            ),
                          ),
                          SizedBox(
                            height: AdaptSize.screenHeight * .01,
                          ),
                          dividerWdiget(
                            width: double.infinity,
                            opacity: .1,
                          ),
                          SizedBox(
                            height: AdaptSize.screenHeight * .01,
                          ),
                        ],
                      );
                    }),
              ),
              SizedBox(
                height: AdaptSize.pixel10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget descriptionsWidget(context, String text) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AdaptSize.screenWidth * .022,
        AdaptSize.screenHeight * .005,
        AdaptSize.screenWidth * .022,
        AdaptSize.screenHeight * .02,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: dividerWdiget(
              width: AdaptSize.screenWidth * 0.1,
              opacity: .4,
            ),
          ),
          Text(
            'Description',
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(fontSize: AdaptSize.pixel16),
          ),
          SizedBox(
            height: AdaptSize.screenHeight * 0.01,
          ),
          Text(
            text,
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  fontSize: AdaptSize.pixel14,
                ),
          ),
          SizedBox(
            height: AdaptSize.pixel14,
          ),
        ],
      ),
    );
  }
}
