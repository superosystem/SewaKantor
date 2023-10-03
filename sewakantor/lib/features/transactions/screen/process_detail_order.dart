import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sewakantor/core/network/network_aware.dart';
import 'package:sewakantor/core/network/no_connection_screen.dart';
import 'package:sewakantor/core/parsers.dart';
import 'package:sewakantor/features/auth/view_model/login_view_models.dart';
import 'package:sewakantor/features/locations/view_model/get_location_view_model.dart';
import 'package:sewakantor/features/navigation/view_model/navigasi_view_model.dart';
import 'package:sewakantor/features/offices/view_model/office_view_models.dart';
import 'package:sewakantor/features/offices/widget/detail_order_card.dart';
import 'package:sewakantor/features/reviews/screen/add_review_screen.dart';
import 'package:sewakantor/features/transactions/widget/booking_button_widget.dart';
import 'package:sewakantor/features/transactions/widget/booking_status_widget.dart';
import 'package:sewakantor/features/transactions/widget/info_onprocessed_widget.dart';
import 'package:sewakantor/features/transactions/widget/qr_checkin_widget.dart';
import 'package:sewakantor/src/model/transaction_model/transaction_models.dart';
import 'package:sewakantor/utils/adapt_size.dart';
import 'package:sewakantor/utils/colors.dart';
import 'package:sewakantor/utils/remove_trailing_zero.dart';
import 'package:sewakantor/widgets/bottom_card.dart';
import 'package:sewakantor/widgets/default_appbar_widget.dart';
import 'package:sewakantor/widgets/divider_widget.dart';
import 'package:sewakantor/widgets/icon_with_label.dart';

class ProcessDetailOrderScreens extends StatefulWidget {
  final Widget statusTransaction;
  final bool isNewTransaction;
  final UserTransaction? requestedModels;
  final CreateTransactionModels? requestedCreateTransactionModel;

  const ProcessDetailOrderScreens({
    super.key,
    required this.isNewTransaction,
    required this.statusTransaction,
    this.requestedModels,
    this.requestedCreateTransactionModel,
  });

  @override
  State<ProcessDetailOrderScreens> createState() =>
      _ProcessDetailOrderScreensState();
}

class _ProcessDetailOrderScreensState extends State<ProcessDetailOrderScreens> {
  @override
  void initState() {
    super.initState();
    final providerOfUser = Provider.of<LoginViewModels>(context, listen: false);
    final providerOfOffice =
        Provider.of<OfficeViewModels>(context, listen: false);
    if (providerOfUser.userModels == null) {
      providerOfUser.getProfile();
    }
    if (providerOfOffice.listOfAllOfficeModels.isEmpty) {
      providerOfOffice.fetchAllOffice();
    }

    widget.statusTransaction;
  }

  @override
  Widget build(BuildContext context) {
    final providerOfUser = Provider.of<LoginViewModels>(context, listen: false);

    UserTransaction? bookingData = widget.requestedModels ??
        parseCreateTransactionToUserTransaction(
            requestedModel: widget.requestedCreateTransactionModel,
            usedUserModel: providerOfUser.userModels!);

    final locationProvider =
        Provider.of<GetLocationViewModel>(context, listen: false);

    // final providerOfOffices =
    //     Provider.of<OfficeViewModels>(context, listen: false);

    return Scaffold(
      resizeToAvoidBottomInset: true,

      /// mengganti appbar
      appBar: defaultAppbarWidget(
        contexts: context,
        leadIconFunction: () {
          context.read<NavigasiViewModel>().navigasiPop(context);
        },
        isCenterTitle: false,
        titles: 'Detail Order',
      ),
      body: NetworkAware(
        offlineChild: const NoConnectionScreen(),
        onlineChild: Column(
          children: [
            Flexible(
              fit: FlexFit.loose,
              flex: 12,
              child: Padding(
                padding: EdgeInsets.only(
                  top: AdaptSize.pixel8,
                  right: AdaptSize.screenWidth * .016,
                  left: AdaptSize.screenWidth * .016,
                ),
                child: ListView(
                  children: [
                    /// status order widget
                    bookingData != null
                        ? bookingData.Status == "on process"
                            ? infoOnProcess(context)
                            : bookingData.Status == "rejected"
                                ? const SizedBox()
                                : const SizedBox()
                        : const SizedBox(),

                    Padding(
                      padding: EdgeInsets.only(
                          top: AdaptSize.pixel8, bottom: AdaptSize.pixel16),
                      child: Row(
                        children: [
                          Text(
                            "Status",
                            style:
                                Theme.of(context).textTheme.headline6!.copyWith(
                                      color: MyColor.neutral100,
                                      fontSize: AdaptSize.pixel16,
                                    ),
                          ),
                          const Spacer(),

                          /// status order widget
                          bookingData != null
                              ? bookingData.Status == "on process"
                                  ? BookingStatusWidget.statusOnProcess(context)
                                  : bookingData.Status == "rejected"
                                      ? BookingStatusWidget.statusCancelled(
                                          context)
                                      : BookingStatusWidget.statusSuccess(
                                          context)
                              : BookingStatusWidget.statusOnProcess(context),
                        ],
                      ),
                    ),

                    /// card detail order
                    detailOrderCard(
                      context: context,
                      officeImage: bookingData?.officeData?.officeLeadImage !=
                              null
                          ? bookingData!.officeData!.officeLeadImage
                          : 'https://cdn1-production-images-kly.akamaized.net/sBbpp2jnXav0YR8a_VVFjMtCCJQ=/1200x1200/smart/filters:quality(75):strip_icc():format(jpeg)/kly-media-production/medias/882764/original/054263300_1432281574-Boruto-Naruto-the-Movie-trailer.jpg',
                      officeName:
                          bookingData?.officeData?.officeName ?? "placeholder",
                      officeLocation:
                          bookingData?.officeData?.officeName ?? "placeholder",
                      officeApproxDistance: locationProvider.posisi != null
                          ? locationProvider.calculateDistances(
                                  locationProvider.lat,
                                  locationProvider.lng,
                                  bookingData?.officeData?.officeLocation
                                      .officeLatitude,
                                  bookingData?.officeData?.officeLocation
                                      .officeLongitude) ??
                              '-'
                          : '-',
                      officePersonCapacity: bookingData?.officeData != null
                          ? bookingData!.officeData!.officePersonCapacity
                              .toString()
                              .replaceAll(RemoveTrailingZero.regex, '')
                          : "999",
                      officeArea: bookingData?.officeData != null
                          ? bookingData!.officeData!.officeArea
                              .toString()
                              .replaceAll(RemoveTrailingZero.regex, '')
                          : "999",
                      officeType: bookingData?.officeData?.officeType ??
                          'coworking space',
                    ),

                    SizedBox(
                      height: AdaptSize.screenHeight * .016,
                    ),

                    Text(
                      "Reservation Detail",
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: MyColor.neutral100,
                          fontSize: AdaptSize.pixel16),
                    ),

                    SizedBox(
                      height: AdaptSize.screenHeight * .016,
                    ),

                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: AdaptSize.screenHeight * .01),
                              child: IconWithLabel().asrow(
                                iconColor: MyColor.secondary400,
                                spacer: AdaptSize.screenHeight * .016,
                                contexts: context,
                                usedIcon: Icons.account_circle_outlined,
                                labelText: bookingData != null
                                    ? bookingData
                                        .userData.userProfileDetails.userName
                                    : "Fadli Rahmadan",
                                iconSize: AdaptSize.pixel24,
                                fontSizes: AdaptSize.pixel14,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: AdaptSize.screenHeight * .01),
                              child: IconWithLabel().asrow(
                                iconColor: MyColor.secondary400,
                                spacer: AdaptSize.screenHeight * .016,
                                contexts: context,
                                usedIcon: Icons.calendar_month_outlined,
                                labelText: bookingData != null
                                    ? widget.isNewTransaction == false
                                        ? DateFormat('EEEE, d MMMM yyyy')
                                            .format(parseApiFormatDateTime(
                                                apiFormattedDateTime:
                                                    bookingData.bookingTime
                                                        .checkInDate)!)
                                        : DateFormat('EEEE, d MMMM yyyy')
                                            .format(parseApiFormatDateTime2(
                                                apiFormattedDateTime:
                                                    bookingData.bookingTime
                                                        .checkInDate)!)
                                    : "placeholder",
                                iconSize: AdaptSize.pixel24,
                                fontSizes: AdaptSize.pixel14,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: AdaptSize.screenHeight * .01),
                              child: IconWithLabel().asrow(
                                iconColor: MyColor.secondary400,
                                spacer: AdaptSize.screenHeight * .016,
                                contexts: context,
                                usedIcon: Icons.access_time_outlined,
                                labelText:
                                    bookingData?.bookingTime.checkInHour ??
                                        "placeholder",
                                iconSize: AdaptSize.pixel24,
                                fontSizes: AdaptSize.pixel14,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: AdaptSize.screenHeight * .01),
                              child: IconWithLabel().asrow(
                                iconColor: MyColor.secondary400,
                                spacer: AdaptSize.screenHeight * .016,
                                contexts: context,
                                usedIcon: Icons.emoji_food_beverage_outlined,
                                labelText: bookingData?.Drink ?? "placeholder",
                                iconSize: AdaptSize.pixel24,
                                fontSizes: AdaptSize.pixel14,
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    /// garis bawah
                    dividerWdiget(width: double.infinity, opacity: .1),

                    Padding(
                      padding: EdgeInsets.only(
                          bottom: AdaptSize.screenHeight * .016),
                      child: Text(
                        "Reservation Detail",
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                            color: MyColor.neutral100,
                            fontSize: AdaptSize.pixel16),
                      ),
                    ),

                    /// payment method
                    Padding(
                      padding:
                          EdgeInsets.only(bottom: AdaptSize.screenHeight * .01),
                      child: Row(
                        children: [
                          Text(
                            "Payment Method",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: MyColor.neutral100,
                                  fontSize: AdaptSize.pixel14,
                                ),
                          ),
                          const Spacer(),
                          Text(
                            bookingData?.paymentMethod.paymentMethodName ??
                                "placeholder",
                            style:
                                Theme.of(context).textTheme.headline6!.copyWith(
                                      color: MyColor.neutral100,
                                      fontSize: AdaptSize.pixel14,
                                    ),
                          ),
                        ],
                      ),
                    ),

                    /// total price
                    Padding(
                      padding:
                          EdgeInsets.only(bottom: AdaptSize.screenHeight * .01),
                      child: Row(
                        children: [
                          Text(
                            "Total Price",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: MyColor.neutral100,
                                    fontSize: AdaptSize.pixel14),
                          ),
                          const Spacer(),
                          Text(
                            NumberFormat.currency(
                                    locale: 'id',
                                    symbol: 'Rp ',
                                    decimalDigits: 0)
                                .format(bookingData?.bookingOfficePrice ??
                                    999999999),
                            style:
                                Theme.of(context).textTheme.headline6!.copyWith(
                                      color: MyColor.neutral100,
                                      fontSize: AdaptSize.pixel14,
                                    ),
                          ),
                        ],
                      ),
                    ),

                    /// price hour text
                    Padding(
                      padding:
                          EdgeInsets.only(bottom: AdaptSize.screenHeight * .01),
                      child: Row(
                        children: [
                          Text(
                            bookingData?.officeData?.officeType == "Office"
                                ? " Price/Month"
                                : " Price/Hour",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: MyColor.neutral100,
                                    fontSize: AdaptSize.pixel14),
                          ),
                          const Spacer(),
                          Text(
                            NumberFormat.currency(
                                        locale: 'id',
                                        symbol: 'Rp ',
                                        decimalDigits: 0)
                                    .format(bookingData?.officeData
                                            ?.officePricing.officePrice ??
                                        35000) +
                                (bookingData?.officeData?.officeType == "Office"
                                    ? " /month"
                                    : " /hour"),
                            style:
                                Theme.of(context).textTheme.headline6!.copyWith(
                                      color: MyColor.neutral100,
                                      fontSize: AdaptSize.pixel14,
                                    ),
                          ),
                        ],
                      ),
                    ),

                    /// duration text
                    Padding(
                      padding:
                          EdgeInsets.only(bottom: AdaptSize.screenHeight * .01),
                      child: Row(
                        children: [
                          Text(
                            "Duration",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: MyColor.neutral100,
                                    fontSize: AdaptSize.pixel14),
                          ),
                          const Spacer(),
                          Text(
                            (((bookingData?.bookingOfficePrice ?? 90) /
                                            (bookingData
                                                    ?.officeData
                                                    ?.officePricing
                                                    .officePrice ??
                                                4))
                                        .round())
                                    .toString() +
                                (bookingData?.officeData?.officeType == "Office"
                                    ? " month"
                                    : " hour"),
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(
                                    color: MyColor.neutral100,
                                    fontSize: AdaptSize.pixel14),
                          ),
                        ],
                      ),
                    ),

                    /// service text
                    Padding(
                      padding:
                          EdgeInsets.only(bottom: AdaptSize.screenHeight * .01),
                      child: Row(
                        children: [
                          Text(
                            "Service",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: MyColor.neutral100,
                                    fontSize: AdaptSize.pixel14),
                          ),
                          const Spacer(),
                          Text(
                            NumberFormat.currency(
                                    locale: 'id',
                                    symbol: 'Rp ',
                                    decimalDigits: 0)
                                .format(10000),
                            style:
                                Theme.of(context).textTheme.headline6!.copyWith(
                                      color: MyColor.neutral100,
                                      fontSize: AdaptSize.pixel14,
                                    ),
                          ),
                        ],
                      ),
                    ),

                    dividerWdiget(width: double.infinity, opacity: .1),

                    /// total text
                    Padding(
                      padding:
                          EdgeInsets.only(bottom: AdaptSize.screenHeight * .01),
                      child: Row(
                        children: [
                          Text(
                            "Total",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: MyColor.neutral100,
                                    fontSize: AdaptSize.pixel14),
                          ),
                          const Spacer(),
                          Text(
                            NumberFormat.currency(
                                    locale: 'id',
                                    symbol: 'Rp ',
                                    decimalDigits: 0)
                                .format(
                                    ((((bookingData?.bookingOfficePrice ?? 90) /
                                                    (bookingData
                                                            ?.officeData
                                                            ?.officePricing
                                                            .officePrice ??
                                                        4)) *
                                                (bookingData
                                                        ?.officeData
                                                        ?.officePricing
                                                        .officePrice ??
                                                    2)) +
                                            10000)
                                        .round()),
                            style:
                                Theme.of(context).textTheme.headline6!.copyWith(
                                      color: MyColor.neutral100,
                                      fontSize: AdaptSize.pixel14,
                                    ),
                          ),
                        ],
                      ),
                    ),

                    /// ppn
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: AdaptSize.screenHeight * .016),
                      child: Row(
                        children: [
                          Text(
                            "PPN(11%)",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: MyColor.neutral100,
                                    fontSize: AdaptSize.pixel14),
                          ),
                          const Spacer(),
                          Text(
                            NumberFormat.currency(
                                    locale: 'id',
                                    symbol: 'Rp ',
                                    decimalDigits: 0)
                                .format(((((((bookingData?.bookingOfficePrice ??
                                                            90) /
                                                        (bookingData
                                                                ?.officeData
                                                                ?.officePricing
                                                                .officePrice ??
                                                            4)) *
                                                    (bookingData
                                                            ?.officeData
                                                            ?.officePricing
                                                            .officePrice ??
                                                        2)) +
                                                10000)
                                            .round()) /
                                        100) *
                                    11),
                            style:
                                Theme.of(context).textTheme.headline6!.copyWith(
                                      color: MyColor.neutral100,
                                      fontSize: AdaptSize.pixel14,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// footer
            bookingData != null
                ? bookingData.Status == "on process"
                    ? partialRoundedCard(
                        childWidgets: BookingButtonWidget.disableButton(
                          context: context,
                          paddingBottom: AdaptSize.pixel16,
                        ),
                        cardBottomPadding: 0,
                        cardTopLeftRadius: 8,
                        cardTopRightRadius: 8)
                    : bookingData.Status == "rejected"
                        ? partialRoundedCard(
                            childWidgets: BookingButtonWidget.disableButton(
                              context: context,
                              paddingBottom: AdaptSize.pixel16,
                            ),
                            cardBottomPadding: 0,
                            cardTopLeftRadius: 8,
                            cardTopRightRadius: 8,
                          )
                        : partialRoundedCard(
                            childWidgets: Column(
                              children: [
                                BookingButtonWidget.checkinDetailOrderButton(
                                  context: context,
                                  onPressed: () {
                                    qrCodeCheckIn(
                                        context: context,
                                        title: 'QR Code',
                                        description:
                                            'Show the QR Code to the staff',
                                        qrCodeData:
                                            'bookingId:${bookingData.bookingId}, paymentMethod:${bookingData.paymentMethod.paymentId}, bookingCheckInDate${bookingData.bookingTime.checkInDate}, userId:${bookingData.userData.userId} email:${bookingData.userData.userEmail}');
                                  },
                                  buttonText: 'Check-in Now',
                                  paddingTop: AdaptSize.pixel14,
                                  paddingBottom: AdaptSize.screenHeight * .014,
                                ),
                                BookingButtonWidget.avaliableButton(
                                    context: context,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) => AddReviewScreen(
                                            isNewTransaction: false,
                                            requestedModels: bookingData,
                                          ),
                                        ),
                                      );
                                    },
                                    paddingTop: 0,
                                    paddingBottom: AdaptSize.pixel14,
                                    buttonText: 'Add Review'),
                              ],
                            ),
                            cardBottomPadding: 0,
                            cardTopLeftRadius: 8,
                            cardTopRightRadius: 8,
                          )
                : partialRoundedCard(
                    childWidgets: BookingButtonWidget.disableButton(
                      context: context,
                      paddingBottom: AdaptSize.pixel16,
                    ),
                    cardBottomPadding: 0,
                    cardTopLeftRadius: 8,
                    cardTopRightRadius: 8,
                  ),
          ],
        ),
      ),
    );
  }
}
