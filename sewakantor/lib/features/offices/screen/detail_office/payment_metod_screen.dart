import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sewakantor/core/network/network_aware.dart';
import 'package:sewakantor/core/network/no_connection_screen.dart';
import 'package:sewakantor/features/navigation/view_model/navigasi_view_model.dart';
import 'package:sewakantor/data/model/transactions/transactions_models.dart';
import 'package:sewakantor/utils/adapt_size.dart';
import 'package:sewakantor/utils/colors.dart';
import 'package:sewakantor/widgets/button_widget.dart';
import 'package:sewakantor/widgets/custom_radio_button.dart';
import 'package:sewakantor/widgets/default_appbar_widget.dart';
import 'package:sewakantor/widgets/divider_widget.dart';

class PaymentMetodScreen extends StatelessWidget {
  final String officeId;
  final TransactionFormModels checkoutForms;
  final String durationTimeUnit;

  const PaymentMetodScreen({
    Key? key,
    required this.officeId,
    required this.checkoutForms,
    required this.durationTimeUnit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final listOfPaymentModels = PaymentModels().listOfAvailablePaymentMethod;
    ValueNotifier<int> radPaymentVal = ValueNotifier<int>(0);
    debugPrint("calculated price : ${checkoutForms.transactionTotalPrice}");

    return Scaffold(
      appBar: defaultAppbarWidget(
          contexts: context,
          leadIconFunction: () {
            context.read<NavigasiViewModel>().navigasiPop(context);
          },
          isCenterTitle: false,
          titles: 'Payment Method'),
      body: NetworkAware(
        offlineChild: const NoConnectionScreen(),
        onlineChild: Padding(
          padding: EdgeInsets.only(
            left: AdaptSize.screenWidth * .016,
            right: AdaptSize.screenWidth * .016,
            bottom: AdaptSize.screenHeight * .024,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: AdaptSize.screenHeight * .016,
              ),
              Text(
                'Choice Payment Method',
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontSize: AdaptSize.pixel16,
                      color: MyColor.neutral300,
                    ),
              ),

              SizedBox(
                height: AdaptSize.screenHeight * .016,
              ),

              /// qris method
              Card(
                color: MyColor.neutral900,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Scan QR Code',
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              fontSize: AdaptSize.pixel16,
                              color: MyColor.neutral100,
                            ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/image_assets/qris_payment.png',
                            height: AdaptSize.screenHeight * .03,
                          ),
                          SizedBox(
                            width: AdaptSize.screenWidth * .016,
                          ),
                          Text(
                            'QRIS (Dana, OVO, Gopay,etc)',
                            style:
                                Theme.of(context).textTheme.bodyText2!.copyWith(
                                      fontSize: AdaptSize.pixel14,
                                      color: MyColor.neutral100,
                                    ),
                          ),
                          const Spacer(),

                          /// qris value
                          customRadioButton(
                            context: context,
                            customRadioController: radPaymentVal,
                            controlledIdValue: radPaymentVal.value,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),

              SizedBox(
                height: AdaptSize.screenHeight * .016,
              ),

              /// transfer atm method
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: MyColor.neutral900,
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Transfer ATM / M-Banking',
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              fontSize: AdaptSize.pixel16,
                              color: MyColor.neutral100,
                            ),
                      ),
                      SizedBox(
                        height: AdaptSize.screenWidth / 1000 * 800,
                        width: double.infinity,
                        child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: listOfPaymentModels.length - 1,
                            itemBuilder: (context, index) {
                              int formattedIndex = index + 1;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        listOfPaymentModels[formattedIndex]
                                            .paymentMethodImageSlug,
                                        height: AdaptSize.screenHeight * .03,
                                        width: AdaptSize.screenHeight * .05,
                                      ),
                                      SizedBox(
                                        width: AdaptSize.screenWidth * .016,
                                      ),
                                      Text(
                                        listOfPaymentModels[formattedIndex]
                                            .paymentMethodName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2!
                                            .copyWith(
                                              fontSize: AdaptSize.pixel14,
                                              color: MyColor.neutral100,
                                            ),
                                      ),
                                      const Spacer(),

                                      ///bank transfer value
                                      customRadioButton(
                                        context: context,
                                        customRadioController: radPaymentVal,
                                        controlledIdValue: formattedIndex,
                                      ),
                                    ],
                                  ),
                                  dividerWdiget(
                                      width: double.infinity, opacity: .1)
                                ],
                              );
                            }),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              buttonWidget(
                onPressed: () {
                  debugPrint(radPaymentVal.value.toString());
                  context.read<NavigasiViewModel>().navigasiToPaymentDetail(
                        context: context,
                        officeId: officeId,
                        bookingForm: CreateTransactionModels(
                            officeData: checkoutForms.officeData,
                            transactionTotalPrice:
                                checkoutForms.transactionTotalPrice,
                            transactionBookingTime:
                                checkoutForms.transactionBookingTime,
                            duration: checkoutForms.duration,
                            paymentMethodName:
                                listOfPaymentModels[radPaymentVal.value]
                                    .paymentMethodName,
                            selectedDrink: checkoutForms.selectedDrink,
                            selectedOfficeId: checkoutForms.selectedOfficeId),
                        paymentMethodIndex: radPaymentVal.value,
                        durationTimeUnit: durationTimeUnit,
                      );
                },
                sizeWidth: double.infinity,
                sizeheight: AdaptSize.screenHeight / 14,
                borderRadius: BorderRadius.circular(10),
                backgroundColor: MyColor.secondary400,
                child: Text(
                  'Continue Payment',
                  style: Theme.of(context).textTheme.button!.copyWith(
                        color: MyColor.neutral900,
                        fontSize: AdaptSize.pixel14,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
