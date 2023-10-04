import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sewakantor/core/network/network_aware.dart';
import 'package:sewakantor/core/network/no_connection_screen.dart';
import 'package:sewakantor/core/parsers.dart';
import 'package:sewakantor/data/model/offices/office_dummy_data.dart';
import 'package:sewakantor/data/model/offices/office_dummy_models.dart';
import 'package:sewakantor/features/auth/view_model/login_view_models.dart';
import 'package:sewakantor/features/home/widget/home_screen_widget/table_bank_payment_method.dart';
import 'package:sewakantor/features/home/widget/voucer_promo_widget/text_table_content.dart';
import 'package:sewakantor/features/locations/view_model/get_location_view_model.dart';
import 'package:sewakantor/features/navigation/view_model/navigasi_view_model.dart';
import 'package:sewakantor/features/offices/view_model/office_view_models.dart';
import 'package:sewakantor/features/offices/widget/office_type_card.dart';
import 'package:sewakantor/features/promo/view_model/promo_view_model.dart';
import 'package:sewakantor/features/transactions/view_model/transaction_view_model.dart';
import 'package:sewakantor/features/transactions/view_model/transaction_view_models.dart';
import 'package:sewakantor/data/model/transactions/transactions_models.dart';
import 'package:sewakantor/utils/adapt_size.dart';
import 'package:sewakantor/utils/colors.dart';
import 'package:sewakantor/utils/custom_icons.dart';
import 'package:sewakantor/utils/enums.dart';
import 'package:sewakantor/utils/remove_trailing_zero.dart';
import 'package:sewakantor/widgets/button_widget.dart';
import 'package:sewakantor/widgets/default_appbar_widget.dart';
import 'package:sewakantor/widgets/divider_widget.dart';
import 'package:sewakantor/widgets/line_dash_widget.dart';
import 'package:sewakantor/widgets/loading_widget.dart';

class PaymentDetailScreen extends StatefulWidget {
  final String officeId;
  final CreateTransactionModels bookingForms;
  final int paymentMethodPointerIndex;
  final String durationTimeUnits;

  const PaymentDetailScreen(
      {Key? key,
      required this.officeId,
      required this.bookingForms,
      required this.paymentMethodPointerIndex,
      required this.durationTimeUnits})
      : super(key: key);

  @override
  State<PaymentDetailScreen> createState() => _PaymentDetailScreenState();
}

class _PaymentDetailScreenState extends State<PaymentDetailScreen> {
  @override
  Widget build(BuildContext context) {
    // final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
    final userAccountProviderListen =
        Provider.of<LoginViewModels>(context, listen: true);
    final listOfPaymentModels = PaymentModels().listOfAvailablePaymentMethod;
    final officeListAlloffice =
        Provider.of<OfficeViewModels>(context, listen: true);
    List<OfficeModels> listOfAllOfficeContainers =
        officeListAlloffice.listOfAllOfficeModels;

    final officeById = officeModelFilterByOfficeId(
        listOfModels: listOfAllOfficeContainers,
        requestedOfficeId: widget.officeId);

    final transactionProvider =
        Provider.of<TransactionViewModel>(context, listen: false);

    final dummyDataProviders =
        Provider.of<OfficeDummyDataViewModels>(context, listen: false);

    final listOfDummyOffice = dummyDataProviders.listOfOfficeModels;

    final createUserTransaction =
        Provider.of<TransactionViewModels>(context, listen: false);

    debugPrint(widget.bookingForms.paymentMethodName);

    List<ReservationDetailModel> listOfReservationDetail = ReservationDetails(
            userName: userAccountProviderListen
                    .userModels?.userProfileDetails.userName ??
                "name placeholder",
            checkInDate:
                widget.bookingForms.transactionBookingTime.checkInDateTime ??
                    DateTime.now(),
            checkInTime: widget.bookingForms.transactionBookingTime.checkInHour,
            checkOutTime:
                widget.bookingForms.transactionBookingTime.checkOutHour ??
                    "_hour",
            duration: widget.bookingForms.duration,
            durationUnit: widget.durationTimeUnits,
            requestedDrink: widget.bookingForms.selectedDrink)
        .reservationDetailData;

    return Scaffold(
      appBar: defaultAppbarWidget(
          contexts: context,
          leadIconFunction: () {
            context.read<NavigasiViewModel>().navigasiPop(context);
          },
          isCenterTitle: false,
          titles: 'Payment Detail'),
      body: NetworkAware(
        offlineChild: const NoConnectionScreen(),
        onlineChild: SingleChildScrollView(
          physics: const ScrollPhysics(),
          padding: EdgeInsets.only(
            top: AdaptSize.screenHeight * .016,
            left: AdaptSize.screenWidth * .016,
            right: AdaptSize.screenWidth * .016,
            bottom: AdaptSize.screenHeight * .024,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// header
              Row(
                children: [
                  Text(
                    'Complete in',
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(fontSize: AdaptSize.pixel16),
                  ),
                  const Spacer(),

                  /// timer countdown
                  TweenAnimationBuilder<Duration>(
                      duration: const Duration(hours: 60),
                      tween: Tween(
                        begin: const Duration(hours: 60),
                        end: Duration.zero,
                      ),
                      onEnd: () {
                        /// blm di custom
                        debugPrint('Timer ended');
                      },
                      builder: (BuildContext context, Duration value,
                          Widget? child) {
                        final hours = value.inHours % 60;
                        final minutes = value.inMinutes % 60;
                        final seconds = value.inSeconds % 60;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            '$hours:$minutes:$seconds',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(
                                    color: MyColor.danger300,
                                    fontSize: AdaptSize.pixel16),
                          ),
                        );
                      }),
                ],
              ),

              SizedBox(
                height: AdaptSize.screenHeight * .016,
              ),

              Consumer<GetLocationViewModel>(builder: (context, value, child) {
                return officeTypeItemCards(
                  context: context,
                  officeImage: officeById?.officeLeadImage ??
                      listOfDummyOffice[0].officeLeadImage,
                  officeName:
                      officeById?.officeName ?? listOfDummyOffice[0].officeName,
                  officeLocation:
                      '${officeById?.officeLocation.district ?? listOfDummyOffice[0].officeLocation.district}, ${officeById?.officeLocation.city ?? listOfDummyOffice[0].officeLocation.city}',
                  officeStarRanting: officeById?.officeStarRating.toString() ??
                      listOfDummyOffice[0].officeStarRating.toString(),
                  officeApproxDistance: value.posisi != null
                      ? value.calculateDistances(
                          value.lat,
                          value.lng,
                          officeById?.officeLocation.officeLatitude,
                          officeById?.officeLocation.officeLongitude,
                        )!
                      : '-',
                  officePersonCapacity: officeById?.officePersonCapacity
                          .toString()
                          .replaceAll(RemoveTrailingZero.regex, '') ??
                      listOfDummyOffice[0].officePersonCapacity.toString(),
                  officeArea: officeById?.officeArea
                          .toString()
                          .replaceAll(RemoveTrailingZero.regex, '') ??
                      listOfDummyOffice[0].officeArea.toString(),
                  officeType:
                      officeById?.officeType ?? listOfDummyOffice[0].officeType,
                );
              }),

              SizedBox(
                height: AdaptSize.screenHeight * .016,
              ),

              headlineTitle('Payment Method'),

              SizedBox(
                height: AdaptSize.screenHeight * .016,
              ),

              /// text scan qr code
              Row(
                children: [
                  Image.asset(
                      listOfPaymentModels[widget.paymentMethodPointerIndex]
                          .paymentMethodImageSlug),
                  SizedBox(
                    height: AdaptSize.screenWidth * .016,
                  ),
                  Text(
                    widget.paymentMethodPointerIndex == 0
                        ? ' Scan QR Code'
                        : ' Virtual Account',
                    // : ' ${listOfPaymentModels[widget.paymentMethodPointerIndex]
                    // .paymentMethodName}',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(fontSize: AdaptSize.pixel14),
                  ),
                ],
              ),

              /// payment / qr code
              Center(
                child: widget.paymentMethodPointerIndex == 0
                    ? Container(
                        height: AdaptSize.screenWidth / 500 * 200,
                        width: AdaptSize.screenWidth / 500 * 200,
                        margin: EdgeInsets.only(
                          top: AdaptSize.screenHeight * .016,
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
                          data: listOfPaymentModels[
                                  widget.paymentMethodPointerIndex]
                              .qrGenerateable!,
                          barcode: Barcode.qrCode(),
                        ),
                      )
                    : Container(
                        height: AdaptSize.screenWidth / 1000 * 140,
                        width: double.infinity,
                        margin: EdgeInsets.only(top: AdaptSize.pixel10),
                        padding: EdgeInsets.only(left: AdaptSize.pixel12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: MyColor.neutral700,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              listOfPaymentModels[
                                      widget.paymentMethodPointerIndex]
                                  .paymentVirtualAccount!,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(
                                    fontSize: AdaptSize.pixel14,
                                  ),
                            ),
                            IconButton(
                              padding: EdgeInsets.zero,
                              splashRadius: 1,
                              onPressed: () {
                                context.read<PromoViewModel>().changeCopyText(
                                    context,
                                    listOfPaymentModels[
                                            widget.paymentMethodPointerIndex]
                                        .paymentVirtualAccount!);
                              },
                              icon: Icon(
                                Icons.copy,
                                size: AdaptSize.pixel20,
                                color: MyColor.neutral700,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),

              /// icon donwload
              widget.paymentMethodPointerIndex == 0
                  ? Center(
                      child: IconButton(
                        onPressed: () {},
                        padding: EdgeInsets.only(
                            bottom: AdaptSize.screenHeight * .016),
                        icon: const Icon(Icons.file_download_outlined),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.only(
                          bottom: AdaptSize.screenHeight * .016),
                    ),

              /// total payment
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Payment',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(fontSize: AdaptSize.pixel14),
                  ),
                  Text(
                    NumberFormat.currency(
                            locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                        .format(widget.bookingForms.transactionTotalPrice),
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: MyColor.darkBlueColor,
                          fontSize: AdaptSize.pixel14,
                        ),
                  ),
                ],
              ),

              SizedBox(
                height: AdaptSize.screenHeight * .008,
              ),

              dividerWdiget(width: double.infinity, opacity: .1),

              SizedBox(
                height: AdaptSize.screenHeight * .008,
              ),

              headlineTitle('Reservation Detail'),

              SizedBox(
                height: AdaptSize.screenHeight * .016,
              ),

              SizedBox(
                height: AdaptSize.screenWidth / 3,
                width: double.infinity,
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: listOfReservationDetail.length,
                    itemBuilder: (context, index) {
                      if (listOfReservationDetail.isNotEmpty) {
                        var currentDetail = listOfReservationDetail[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: AdaptSize.pixel8),
                          child: Row(
                            children: [
                              customSVGIconParsers(
                                  iconSlug: currentDetail.iconSlug,
                                  size: AdaptSize.pixel20,
                                  color: MyColor.secondary400),
                              SizedBox(
                                width: AdaptSize.screenWidth * .016,
                              ),
                              Text(
                                currentDetail.detailData,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(fontSize: AdaptSize.pixel14),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return const Text("ada kesalahan");
                      }
                    }),
              ),

              dividerWdiget(width: double.infinity, opacity: .2),

              SizedBox(
                height: AdaptSize.screenHeight * .013,
              ),

              headlineTitle('Summary Detail Payment'),

              SizedBox(
                height: AdaptSize.screenHeight * .016,
              ),

              /// total price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Price',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: MyColor.darkBlueColor,
                          fontSize: AdaptSize.pixel14,
                        ),
                  ),
                  Text(
                    NumberFormat.currency(
                            locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                        .format(widget.bookingForms.transactionTotalPrice),
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          fontSize: AdaptSize.pixel14,
                          color: MyColor.secondary400,
                        ),
                  ),
                ],
              ),

              SizedBox(
                height: AdaptSize.screenHeight * .01,
              ),

              /// garis putus2
              LineDashWidget(color: MyColor.neutral700),

              SizedBox(
                height: AdaptSize.screenHeight * .01,
              ),

              /// price per month/hours
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    officeById?.officeType == "Office"
                        ? 'Price/Month'
                        : 'Price/Hours',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontSize: AdaptSize.pixel14,
                        ),
                  ),
                  Text(
                    NumberFormat.currency(
                                locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                            .format(widget.bookingForms.officeData
                                    ?.officePricing.officePrice ??
                                35000) +
                        (widget.bookingForms.officeData?.officeType == "Office"
                            ? " /month"
                            : " /hour"),
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: MyColor.darkBlueColor,
                          fontSize: AdaptSize.pixel14,
                        ),
                  ),
                ],
              ),

              SizedBox(
                height: AdaptSize.screenHeight * .008,
              ),

              /// discount
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Disc(11%)',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontSize: AdaptSize.pixel14,
                        ),
                  ),
                  Text(
                    NumberFormat.currency(
                            locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                        .format(100000),
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: MyColor.darkBlueColor,
                          fontSize: AdaptSize.pixel14,
                        ),
                  ),
                ],
              ),

              SizedBox(
                height: AdaptSize.screenHeight * .008,
              ),

              ///duration
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Duration',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontSize: AdaptSize.pixel14,
                        ),
                  ),
                  Text(
                    'x${widget.bookingForms.duration} ${widget.durationTimeUnits}',
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: MyColor.darkBlueColor,
                          fontSize: AdaptSize.pixel14,
                        ),
                  ),
                ],
              ),
              SizedBox(
                height: AdaptSize.screenHeight * .008,
              ),

              ///services
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Services',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontSize: AdaptSize.pixel14,
                        ),
                  ),
                  Text(
                    NumberFormat.currency(
                            locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                        .format(10000),
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: MyColor.darkBlueColor,
                          fontSize: AdaptSize.pixel14,
                        ),
                  ),
                ],
              ),

              SizedBox(
                height: AdaptSize.screenHeight * .008,
              ),

              dividerWdiget(width: double.infinity, opacity: .2),

              ///calculate total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontSize: AdaptSize.pixel14,
                        ),
                  ),
                  Text(
                    NumberFormat.currency(
                            locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                        .format(((((widget.bookingForms.transactionTotalPrice) /
                                        (widget.bookingForms.officeData
                                                ?.officePricing.officePrice ??
                                            4)) *
                                    (widget.bookingForms.officeData
                                            ?.officePricing.officePrice ??
                                        2)) +
                                10000)
                            .round()),
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: MyColor.darkBlueColor,
                          fontSize: AdaptSize.pixel14,
                        ),
                  ),
                ],
              ),

              SizedBox(
                height: AdaptSize.screenHeight * .008,
              ),

              ///ppn
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'PPN(11%)',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontSize: AdaptSize.pixel14,
                        ),
                  ),
                  Text(
                    NumberFormat.currency(
                            locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                        .format(
                            ((((((widget.bookingForms.transactionTotalPrice) /
                                                    (widget
                                                            .bookingForms
                                                            .officeData
                                                            ?.officePricing
                                                            .officePrice ??
                                                        4)) *
                                                (widget
                                                        .bookingForms
                                                        .officeData
                                                        ?.officePricing
                                                        .officePrice ??
                                                    2)) +
                                            10000)
                                        .round()) /
                                    100) *
                                11),
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: MyColor.darkBlueColor,
                          fontSize: AdaptSize.pixel14,
                        ),
                  ),
                ],
              ),

              SizedBox(
                height: AdaptSize.screenHeight * .008,
              ),

              dividerWdiget(width: double.infinity, opacity: .1),

              SizedBox(
                height: AdaptSize.screenHeight * .016,
              ),

              /// drop down info
              widget.paymentMethodPointerIndex == 0
                  ? Consumer<TransactionViewModel>(
                      builder: (context, value, child) {
                      return Column(
                        children: [
                          InkWell(
                            splashColor: MyColor.neutral900,
                            onTap: () {
                              transactionProvider.isDropDown();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                headlineTitle('Payment via Scan QR'),
                                value.dropDown1 == false
                                    ? const Icon(
                                        Icons.keyboard_arrow_down_sharp)
                                    : const Icon(Icons.keyboard_arrow_up_sharp)
                              ],
                            ),
                          ),
                          dividerWdiget(width: double.infinity, opacity: .2),

                          /// info payment via qrcode
                          Consumer<TransactionViewModel>(
                              builder: (context, value, child) {
                            return value.dropDown1 == false
                                ? const SizedBox()
                                : textTableContent(
                                    text1:
                                        'Open the application that support QRIS (Dana, Ovo, LinkAja, Shoope Pay, etc)',
                                    text2: 'Select Scan QR Code.',
                                    text3: 'Confirm QR Code.',
                                    text4: 'Input Your PIN',
                                    text5: 'Done',
                                    t5: true,
                                    contentTextStyle: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                          fontSize: AdaptSize.pixel14,
                                        ),
                                    withDivider: false,
                                    bottomDivider: true,
                                  );
                          })
                        ],
                      );
                    })
                  : Column(
                      children: [
                        /// info payment via atm
                        Consumer<TransactionViewModel>(
                            builder: (context, value, child) {
                          return Column(
                            children: [
                              InkWell(
                                splashColor: MyColor.neutral900,
                                onTap: () {
                                  transactionProvider.paymentViaATM();
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    headlineTitle('Payment via ATM'),
                                    value.paymentATM == false
                                        ? const Icon(
                                            Icons.keyboard_arrow_down_sharp)
                                        : const Icon(
                                            Icons.keyboard_arrow_up_sharp)
                                  ],
                                ),
                              ),
                              dividerWdiget(
                                  width: double.infinity, opacity: .2),
                              Consumer<TransactionViewModel>(
                                  builder: (context, value, child) {
                                return value.paymentATM == false
                                    ? const SizedBox()
                                    : textTableBankPaymentMethod(
                                        text1:
                                            'Insert the atm card and enter the pin',
                                        text2: 'Select the pay / buy menu',
                                        text3: 'Select Other',
                                        text4: 'Select Multi Payment',
                                        text5:
                                            'Enter 70014 as the Insitution Code',
                                        text6:
                                            'Input Virtual Account Number, ${listOfPaymentModels[widget.paymentMethodPointerIndex].paymentVirtualAccount!}',
                                        text7: 'Select True',
                                        text8: 'Select Yes',
                                        text9: 'Take the transaction receipt',
                                        text10: 'Payment is complete',
                                      );
                              })
                            ],
                          );
                        }),

                        SizedBox(
                          height: AdaptSize.screenHeight * .016,
                        ),

                        /// info payement via m bank
                        Consumer<TransactionViewModel>(
                            builder: (context, value, child) {
                          return Column(
                            children: [
                              InkWell(
                                splashColor: MyColor.neutral900,
                                onTap: () {
                                  transactionProvider.paymentViaMBank();
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    headlineTitle('Payment via M-Banking'),
                                    value.paymentMBank == false
                                        ? const Icon(
                                            Icons.keyboard_arrow_down_sharp)
                                        : const Icon(
                                            Icons.keyboard_arrow_up_sharp)
                                  ],
                                ),
                              ),
                              dividerWdiget(
                                  width: double.infinity, opacity: .2),
                              Consumer<TransactionViewModel>(
                                  builder: (context, value, child) {
                                return value.paymentMBank == false
                                    ? const SizedBox()
                                    : textTableBankPaymentMethod(
                                        text1:
                                            'Open the ${listOfPaymentModels[widget.paymentMethodPointerIndex].paymentVirtualAccount!} payment banking application on your smartphone',
                                        text2:
                                            'Select the \'${listOfPaymentModels[widget.paymentMethodPointerIndex].paymentMethodName}\' menu and enter the mobile banking access code',
                                        text3:
                                            'After successfully entering mobile banking, select the \'M-Transfer\' menu',
                                        text4:
                                            'Select the \'Interbank\' menu in the M-Transfer menu',
                                        text5:
                                            'Enter a different bank virtual account number',
                                        text6:
                                            'Also select the bank you want to go to and click \'Send\'',
                                        text7:
                                            'Confrim virtual account and account number data',
                                        text8:
                                            'Enter the ${listOfPaymentModels[widget.paymentMethodPointerIndex].paymentVirtualAccount!} mobile banking PIN',
                                        text9:
                                            'Enter the nominal you want to transfer and click \'Send\'',
                                        text10:
                                            'Confirm the transfer once again, after that the transfer process has been successful',
                                      );
                              })
                            ],
                          );
                        })
                      ],
                    ),

              SizedBox(
                height: AdaptSize.screenHeight * .016,
              ),

              Consumer<TransactionViewModels>(
                builder: ((context, value, child) {
                  return buttonWidget(
                    onPressed: () async {
                      await createUserTransaction.createTransactionRecords(
                          requestedModels: widget.bookingForms);
                      if (!mounted) return;
                      context.read<NavigasiViewModel>().navigasiSuccessPayment(
                          context: context,
                          requestedTransactionModel: widget.bookingForms);
                    },
                    backgroundColor: MyColor.secondary400,
                    sizeheight: AdaptSize.screenHeight / 14,
                    borderRadius: BorderRadius.circular(10),
                    sizeWidth: double.infinity,
                    child: value.connectionState == stateOfConnections.isLoading
                        ? LoadingWidget.whiteButtonLoading
                        : Text(
                            'I have already paid',
                            style: Theme.of(context).textTheme.button!.copyWith(
                                color: MyColor.neutral900,
                                fontSize: AdaptSize.pixel14),
                          ),
                  );
                }),
              ),

              /// button have already payment

              SizedBox(
                height: AdaptSize.screenHeight * .016,
              ),

              /// button need help
              Center(
                child: GestureDetector(
                  onTap: () {
                    context.read<TransactionViewModel>().launchWA();
                  },
                  child: Text(
                    'Need Help ?',
                    style: Theme.of(context).textTheme.button!.copyWith(
                        color: MyColor.neutral500, fontSize: AdaptSize.pixel14),
                  ),
                ),
              ),

              SizedBox(
                height: AdaptSize.screenHeight * .016,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// content title
  Widget headlineTitle(String title) {
    return Text(
      title,
      style: Theme.of(context)
          .textTheme
          .headline6!
          .copyWith(fontSize: AdaptSize.pixel16),
    );
  }
}
