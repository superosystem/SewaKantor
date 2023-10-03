import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sewakantor/core/network/network_aware.dart';
import 'package:sewakantor/core/network/no_connection_screen.dart';
import 'package:sewakantor/core/parsers.dart';
import 'package:sewakantor/data/model/offices/office_dummy_data.dart';
import 'package:sewakantor/data/model/offices/office_dummy_models.dart';
import 'package:sewakantor/features/home/widget/horizontal_duration_picker/horizontal_duration_hours.dart';
import 'package:sewakantor/features/locations/view_model/get_location_view_model.dart';
import 'package:sewakantor/features/navigation/view_model/navigasi_view_model.dart';
import 'package:sewakantor/features/offices/view_model/office_view_models.dart';
import 'package:sewakantor/features/offices/widget/office_type_card.dart';
import 'package:sewakantor/features/promo/view_model/promo_view_model.dart';
import 'package:sewakantor/features/spaces/view_model/search_spaces_view_model.dart';
import 'package:sewakantor/src/model/beverage%20model/beverage_models.dart';
import 'package:sewakantor/src/model/transaction_model/transaction_models.dart';
import 'package:sewakantor/utils/adapt_size.dart';
import 'package:sewakantor/utils/colors.dart';
import 'package:sewakantor/utils/remove_trailing_zero.dart';
import 'package:sewakantor/widgets/bottom_card.dart';
import 'package:sewakantor/widgets/button_widget.dart';
import 'package:sewakantor/widgets/custom_radio_button.dart';
import 'package:sewakantor/widgets/default_appbar_widget.dart';
import 'package:sewakantor/widgets/horizontal_month_picker.dart';
import 'package:sewakantor/widgets/horizontal_timepicker.dart';
import 'package:sewakantor/widgets/read_only_form.dart';
import 'package:sewakantor/widgets/text_filed_widget.dart';

class CheckoutScreen extends StatefulWidget {
  final String officeId;

  const CheckoutScreen({super.key, required this.officeId});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  ValueNotifier<int> selectedHour = ValueNotifier<int>(8);
  ValueNotifier<int> selectedHourDuration = ValueNotifier<int>(1);
  ValueNotifier<int> selectedMonth = ValueNotifier<int>(1);
  ValueNotifier<int> selectedBeverageId = ValueNotifier<int>(1);
  ValueNotifier<DateTime?> selectedDate = ValueNotifier<DateTime?>(null);
  TextEditingController discountFormController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    discountFormController.dispose();
    _dateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dummyDataProviders =
        Provider.of<OfficeDummyDataViewModels>(context, listen: false);
    List<OfficeModels> listOfDummyOffice =
        dummyDataProviders.listOfOfficeModels;

    final officeListAlloffice =
        Provider.of<OfficeViewModels>(context, listen: true);
    List<OfficeModels> listOfAllOfficeContainers =
        officeListAlloffice.listOfAllOfficeModels;

    final officeById = officeModelFilterByOfficeId(
        listOfModels: listOfAllOfficeContainers,
        requestedOfficeId: widget.officeId);
    return Scaffold(
      bottomNavigationBar: SizedBox(
        width: AdaptSize.screenWidth,
        child: partialRoundedCard(
            childWidgets: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// update 13 11 22 menyamakan dengan detail screen
                Padding(
                  padding: EdgeInsets.only(
                    top: AdaptSize.pixel16,
                    left: AdaptSize.pixel16,
                    right: AdaptSize.pixel16,
                    bottom: AdaptSize.pixel6,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Start From',
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: MyColor.darkBlueColor,
                                      fontSize: AdaptSize.pixel16,
                                    ),
                          ),
                          Text(
                            NumberFormat.currency(
                                    locale: 'id',
                                    symbol: 'Rp ',
                                    decimalDigits: 0)
                                .format(
                              officeById?.officePricing.officePrice ??
                                  Random().nextDouble() * 400000,
                            ),
                            style:
                                Theme.of(context).textTheme.headline6!.copyWith(
                                      color: MyColor.darkBlueColor,
                                      fontSize: AdaptSize.pixel14,
                                    ),
                          ),
                        ],
                      ),

                      /// button to check out
                      ValueListenableBuilder(
                          valueListenable: selectedMonth,
                          builder: (BuildContext context, valueMonth,
                              Widget? child) {
                            return ValueListenableBuilder(
                              valueListenable: selectedHour,
                              builder: (BuildContext context, valueHours,
                                  Widget? child) {
                                return buttonWidget(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate() &&
                                        officeById != null) {
                                      debugPrint(
                                          "base price : ${officeById.officePricing.officePrice}");
                                      context
                                          .read<NavigasiViewModel>()
                                          .navigasiToPaymentMetod(
                                              context: context,
                                              officeId: widget.officeId,
                                              checkoutForm:
                                                  TransactionFormModels(
                                                officeData: officeById,
                                                transactionTotalPrice: calculateTotalPrice(
                                                    discount: filterPromoByCode(
                                                            promoCode:
                                                                discountFormController
                                                                    .text)
                                                        ?.discountValue,
                                                    basePrice: officeById
                                                        .officePricing
                                                        .officePrice,
                                                    duration: officeById
                                                                .officeType ==
                                                            "Office"
                                                        ? selectedMonth.value
                                                        : selectedHourDuration
                                                            .value),
                                                transactionBookingTime:
                                                    dateTimeParsers(
                                                  selectedHours:
                                                      selectedHour.value,
                                                  selectedDate:
                                                      selectedDate.value ??
                                                          DateTime.now(),
                                                  duration: selectedHourDuration
                                                      .value,
                                                ),
                                                duration:
                                                    selectedHourDuration.value,
                                                selectedDrink:
                                                    listOfBeverages()[
                                                            selectedBeverageId
                                                                    .value -
                                                                1]
                                                        .drinkName,
                                                selectedOfficeId:
                                                    int.parse(widget.officeId),
                                                usedPromo: filterPromoByCode(
                                                    promoCode:
                                                        discountFormController
                                                            .text),
                                              ),
                                              durationTimeUnit:
                                                  officeById.officeType ==
                                                          "Office"
                                                      ? "month"
                                                      : "hour");
                                    }
                                  },
                                  borderRadius: BorderRadius.circular(8),
                                  backgroundColor: MyColor.secondary400,
                                  foregroundColor: MyColor.secondary400,
                                  child: Text(
                                    'Book Now',
                                    style: Theme.of(context)
                                        .textTheme
                                        .button!
                                        .copyWith(
                                          fontSize: AdaptSize.pixel14,
                                          color: MyColor.neutral900,
                                        ),
                                  ),
                                );
                              },
                            );
                          }),
                    ],
                  ),
                ),
                SizedBox(
                  height: AdaptSize.screenHeight * .012,
                ),
              ],
            ),
            cardBottomPadding: 0,
            cardTopLeftRadius: 16,
            cardTopRightRadius: 16),
      ),

      /// 13/12/22 mengganti app bar
      appBar: defaultAppbarWidget(
          contexts: context,
          leadIconFunction: () {
            context.read<NavigasiViewModel>().navigasiPop(context);
          },
          isCenterTitle: false,
          titles: 'Checkout'),
      body: NetworkAware(
        offlineChild: const NoConnectionScreen(),
        onlineChild: Padding(
          /// update 13 12 22 menghapus widget yang bertumpukan
          padding: EdgeInsets.only(
            top: AdaptSize.screenHeight * .016,
            right: AdaptSize.screenWidth * .016,

            /// update 13 12 22 mengubah ukuran padding
            left: AdaptSize.screenWidth * .016,
          ),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                /// update 13 12 22 meenyesuaikan card overflow
                Padding(
                  padding: EdgeInsets.only(bottom: AdaptSize.pixel16),
                  child: Consumer<GetLocationViewModel>(
                      builder: (context, value, child) {
                    return officeTypeItemCards(
                      context: context,
                      officeImage: officeById?.officeLeadImage ??
                          listOfDummyOffice[0].officeLeadImage,
                      officeName: officeById?.officeName ??
                          listOfDummyOffice[0].officeName,
                      officeLocation:
                          '${officeById?.officeLocation.district ?? listOfDummyOffice[0].officeLocation.district}, ${officeById?.officeLocation.city ?? listOfDummyOffice[0].officeLocation.city}',
                      officeStarRanting:
                          officeById?.officeStarRating.toString() ??
                              listOfDummyOffice[0].officeStarRating.toString(),
                      officeApproxDistance: value.posisi != null
                          ? value.calculateDistances(
                              value.lat,
                              value.lng,
                              officeById?.officeLocation.officeLatitude,
                              officeById?.officeLocation.officeLongitude)!
                          : '-',
                      officePersonCapacity: officeById?.officePersonCapacity
                              .toString()
                              .replaceAll(RemoveTrailingZero.regex, '') ??
                          listOfDummyOffice[0].officePersonCapacity.toString(),
                      officeArea: officeById?.officeArea
                              .toString()
                              .replaceAll(RemoveTrailingZero.regex, '') ??
                          listOfDummyOffice[0].officeArea.toString(),
                      officeType: officeById?.officeType ??
                          listOfDummyOffice[0].officeType,
                    );
                  }),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(bottom: AdaptSize.screenHeight * .016),
                  child: SizedBox(
                    height: AdaptSize.pixel22,
                    child: Text(
                      "When You Come?",
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: MyColor.neutral100,
                          fontSize: AdaptSize.pixel16),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(bottom: AdaptSize.screenHeight * .016),
                  child: readOnlyWidget(
                    controller: _dateController,
                    enblBorderRadius: 16,
                    errBorderRadius: 16,
                    fcsBorderRadius: 16,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select date check-in';
                      }
                      return null;
                    },
                    hint: 'day, date month year',
                    textStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: MyColor.grayLightColor,
                        ),
                    onTap: () {
                      pickedDate(context, selectedDate);
                    },
                    suffixIcon: Icon(
                      CupertinoIcons.calendar,
                      color: MyColor.grayLightColor,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(bottom: AdaptSize.screenHeight * .016),
                  child: Text(
                    "Select Time To Checkin",
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: MyColor.neutral100, fontSize: AdaptSize.pixel16),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(bottom: AdaptSize.screenHeight * .016),
                  child: SizedBox(
                    height: AdaptSize.pixel28,
                    child: horizontalTimePicker(
                        contexts: context, isSelected: selectedHour),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(bottom: AdaptSize.screenHeight * .016),
                  child: Text(
                    "For How Long?",
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: MyColor.neutral100, fontSize: AdaptSize.pixel16),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(bottom: AdaptSize.screenHeight * .016),
                  child: SizedBox(
                    height: AdaptSize.pixel28,
                    child:
                        // officeById
                        officeById?.officeType == "Office"
                            ? horizontalMonthPicker(
                                contexts: context, isSelected: selectedMonth)
                            : horizontalHoursPicker(
                                contexts: context,
                                isSelected: selectedHourDuration),
                  ),
                ),
                SizedBox(
                  width: AdaptSize.screenWidth,
                  height: AdaptSize.pixel4,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: MyColor.neutral800),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: AdaptSize.screenHeight * .016,
                      top: AdaptSize.screenHeight * .016),
                  child: SizedBox(
                    width: AdaptSize.screenWidth / 1.097561,
                    child: Text(
                      "Select Free Welcome Drink",
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: MyColor.neutral100,
                          fontSize: AdaptSize.pixel16),
                    ),
                  ),
                ),
                SizedBox(
                  width: AdaptSize.screenWidth / 1.097561,
                  height: AdaptSize.screenWidth / 1.73076923,
                  child: ValueListenableBuilder(
                    valueListenable: selectedBeverageId,
                    builder: ((context, value, child) {
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: listOfBeverages().length,
                        itemBuilder: ((context, index) {
                          BeverageModels currentModel =
                              listOfBeverages()[index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: AdaptSize.pixel16),
                            child: SizedBox(
                              width: AdaptSize.screenWidth / 1.097561,
                              height: AdaptSize.screenWidth / 6.428571428,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: AdaptSize.pixel16),
                                    child: SizedBox(
                                      width:
                                          AdaptSize.screenWidth / 6.428571428,
                                      height:
                                          AdaptSize.screenWidth / 6.428571428,
                                      child: Image(
                                        image:
                                            AssetImage(currentModel.imagePath),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: AdaptSize.screenWidth / 1.875,
                                    height: AdaptSize.screenWidth / 6.428571428,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          currentModel.drinkName,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  color: MyColor.neutral100,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: AdaptSize.pixel14),
                                        ),
                                        const Spacer(),
                                        Text(
                                          currentModel.drinkDescription,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  color: MyColor.neutral100,
                                                  fontSize: AdaptSize.pixel10),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),

                                  /// update 13 12 22 menambah spacer
                                  customRadioButton(
                                      context: context,
                                      customRadioController: selectedBeverageId,
                                      controlledIdValue: currentModel.drinkId),
                                ],
                              ),
                            ),
                          );
                        }),
                      );
                    }),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(bottom: AdaptSize.screenHeight * .016),
                  child: SizedBox(
                    height: AdaptSize.screenWidth / 6.4285714,
                    child: Consumer<PromoViewModel>(
                        builder: (context, value, child) {
                      return textFormFields(
                          prefixIcons: Padding(
                            padding: EdgeInsets.only(
                                right: AdaptSize.pixel14,
                                left: AdaptSize.pixel14),
                            child: SizedBox(
                              height: AdaptSize.pixel18,
                              width: AdaptSize.pixel18,
                              child: SvgPicture.asset(
                                  'assets/svg_assets/discount.svg'),
                            ),
                          ),
                          textInputAction: TextInputAction.done,
                          suffixIcon: Icon(
                            Icons.percent,
                            color: MyColor.primary700,
                            size: AdaptSize.pixel18,
                          ),
                          label: "discount code",
                          textStyle: TextStyle(color: MyColor.neutral400),
                          hintTexts: "AXRRR#2",
                          controller: discountFormController);
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future pickedDate(
      BuildContext context, ValueNotifier<DateTime?> dateController) async {
    final dateProvider =
        Provider.of<SearchSpacesViewModel>(context, listen: false);

    dateProvider.dateNow = (await showDatePicker(
      context: context,
      initialDate: dateProvider.dateTime,
      firstDate: DateTime(1999),
      lastDate: DateTime(2050),
      fieldLabelText: 'Booking Date',
      fieldHintText: 'Month/Date/Year',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: MyColor.darkBlueColor,
              surface: MyColor.whiteColor,
              onPrimary: MyColor.whiteColor,
              onSurface: MyColor.darkColor,
            ),
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: MyColor.darkBlueColor, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    ))!;

    dateProvider.pickdate();
    _dateController.text = dateProvider.datePicked;
    dateController.value = dateProvider.dateTime;
  }
}
