import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sewakantor/core/parsers.dart';
import 'package:sewakantor/features/auth/view_model/login_view_models.dart';
import 'package:sewakantor/features/navigation/view_model/navigasi_view_model.dart';
import 'package:sewakantor/features/offices/widget/card_detail_office_review.dart';
import 'package:sewakantor/features/reviews/view_model/add_review_view_model.dart';
import 'package:sewakantor/features/reviews/view_model/review_view_model.dart';
import 'package:sewakantor/src/model/transaction_model/transaction_models.dart';
import 'package:sewakantor/utils/adapt_size.dart';
import 'package:sewakantor/utils/colors.dart';
import 'package:sewakantor/utils/enums.dart';
import 'package:sewakantor/utils/hex_color_convert.dart';
import 'package:sewakantor/widgets/button_widget.dart';
import 'package:sewakantor/widgets/default_appbar_widget.dart';
import 'package:sewakantor/widgets/dialog/response_dialog.dart';
import 'package:sewakantor/widgets/loading_widget.dart';
import 'package:sewakantor/widgets/text_filed_widget.dart';

class AddReviewScreen extends StatefulWidget {
  final bool isNewTransaction;
  final UserTransaction? requestedModels;
  final CreateTransactionModels? requestedCreateTransactionModel;

  const AddReviewScreen({
    Key? key,
    required this.isNewTransaction,
    this.requestedModels,
    this.requestedCreateTransactionModel,
  }) : super(key: key);

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  final TextEditingController _addReviewDes = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _addReviewDes.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final providerOfUser = Provider.of<LoginViewModels>(context, listen: false);

    UserTransaction? bookingData = widget.requestedModels ??
        parseCreateTransactionToUserTransaction(
            requestedModel: widget.requestedCreateTransactionModel,
            usedUserModel: providerOfUser.userModels!);

    final rantingProvider =
        Provider.of<AddReviewViewModel>(context, listen: false);
    return Scaffold(
      appBar: defaultAppbarWidget(
          contexts: context,
          isCenterTitle: false,
          titles: 'Add Review',
          leadIconFunction: () {
            context.read<NavigasiViewModel>().navigasiPop(context);
          }),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        padding: EdgeInsets.only(
          left: AdaptSize.screenWidth * .016,
          right: AdaptSize.screenWidth * .016,
          top: AdaptSize.screenHeight * .016,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              cardDetailOfficeReview(
                context: context,
                officeImage: bookingData?.officeData?.officeLeadImage != null
                    ? bookingData!.officeData!.officeLeadImage
                    : 'https://cdn1-production-images-kly.akamaized.net/sBbpp2jnXav0YR8a_VVFjMtCCJQ=/1200x1200/smart/filters:quality(75):strip_icc():format(jpeg)/kly-media-production/medias/882764/original/054263300_1432281574-Boruto-Naruto-the-Movie-trailer.jpg',
                officeRanting:
                    bookingData?.officeData?.officeStarRating.toString() ??
                        "0.0",
                officeType:
                    bookingData?.officeData?.officeType ?? "placeholder",
                officeName:
                    bookingData?.officeData?.officeName ?? "placeholder",
                officeLocation:
                    '${bookingData?.officeData?.officeLocation.district ?? "placeholder"}, ${bookingData?.officeData?.officeLocation.city ?? "placeholder"}',
              ),

              SizedBox(
                height: AdaptSize.screenHeight * .016,
              ),

              Text(
                'Your overall rating of the office ',
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      fontSize: AdaptSize.pixel15,
                    ),
              ),

              SizedBox(
                height: AdaptSize.screenHeight * .016,
              ),

              /// star ranting
              Consumer<AddReviewViewModel>(builder: (context, value, child) {
                return SizedBox(
                  height: AdaptSize.screenWidth / 1000 * 120,
                  width: double.infinity,
                  child: Center(
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: value.maximumRating,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            child: buildRatingStar(index, value.currentRating),
                            onTap: () {
                              value.changedRanting(index);
                            },
                          );
                        }),
                  ),
                );
              }),

              SizedBox(
                height: AdaptSize.screenHeight * .016,
              ),

              /// text form field
              textFormFields(
                  maxLines: 4,
                  textInputAction: TextInputAction.done,
                  controller: _addReviewDes,
                  validators: (value) {
                    if (value == null || _addReviewDes.text.isEmpty) {
                      return 'Please give at least 1 word more than 10 letters';
                    }
                    return null;
                  },
                  hintTexts: 'add a description',
                  label: ''),

              SizedBox(
                height: AdaptSize.screenHeight * .016,
              ),

              /// button submit review
              Consumer<ReviewViewModels>(builder: (context, value, child) {
                return buttonWidget(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (rantingProvider.currentRating == 0) {
                        debugPrint(
                            '${_addReviewDes.text}, ${rantingProvider.currentRating}');
                        ResponseDialog.dialogFailed(
                          context: context,
                          title: 'Invalid star submitted',
                          description: 'Ranting star value cannot be empty',
                        );
                      } else {
                        await value.createOfficeReviews(
                            reviewComment: _addReviewDes.text,
                            rating: rantingProvider.currentRating.toDouble(),
                            officeId:
                                int.parse(bookingData!.officeData!.officeID)
                                    .toInt());
                        if (value.connectionState ==
                            stateOfConnections.isReady) {
                          ResponseDialog.dialogSuccess(
                              context: context,
                              description:
                                  'Your review has been submitted, thank you');
                          Future.delayed(const Duration(seconds: 3), () {
                            context
                                .read<NavigasiViewModel>()
                                .navigasiPop(context);
                            _addReviewDes.clear();
                          });
                        }
                      }
                    }
                  },
                  sizeheight: AdaptSize.screenHeight / 14,
                  sizeWidth: double.infinity,
                  borderRadius: BorderRadius.circular(10),
                  backgroundColor: MyColor.secondary400,
                  child: value.connectionState == stateOfConnections.isLoading
                      ? LoadingWidget.whiteButtonLoading
                      : Text(
                          'Submit Review',
                          style: Theme.of(context).textTheme.button!.copyWith(
                                fontSize: AdaptSize.pixel14,
                                color: MyColor.neutral900,
                              ),
                        ),
                );
              })
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRatingStar(int index, int currentRating) {
    if (index < currentRating) {
      return Icon(
        Icons.star,
        color: HexColor('E5D11A'),
        size: AdaptSize.screenWidth / 1000 * 100,
      );
    } else {
      return Icon(
        Icons.star_border_outlined,
        color: MyColor.neutral700,
        size: AdaptSize.screenWidth / 1000 * 100,
      );
    }
  }
}
