import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sewakantor/utils/adapt_size.dart';
import 'package:sewakantor/utils/colors.dart';
import 'package:sewakantor/utils/hex_color_convert.dart';
import 'package:sewakantor/widgets/shimmer_widget.dart';

/// card review
Widget cardReview({
  context,
  required String userImage,
  required String userNameReview,
  required String dateReview,
  required String descriptionReview,
  required int reviewStarLength,
  required int totalHelpful,
  Function()? buttonHelpful,
}) {
  return Container(
    width: AdaptSize.screenWidth / 1000 * 840,
    padding: EdgeInsets.all(AdaptSize.screenHeight * .01),
    margin: EdgeInsets.all(AdaptSize.pixel4),
    decoration: BoxDecoration(
      color: MyColor.neutral900,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          offset: const Offset(1, 2),
          spreadRadius: .2,
          color: MyColor.neutral600.withOpacity(.5),
          blurRadius: 3,
        )
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,

          /// user image
          children: [
            CachedNetworkImage(
              imageUrl: userImage,
              imageBuilder: (context, imageProvider) => CircleAvatar(
                radius: 30,
                backgroundColor: MyColor.neutral700,
                backgroundImage: NetworkImage(
                  userImage,
                ),
              ),
              placeholder: (context, url) => shimmerLoading(
                child: CircleAvatar(
                  backgroundColor: MyColor.neutral700,
                  radius: 30,
                ),
              ),
              errorWidget: (context, url, error) => CircleAvatar(
                radius: 30,
                backgroundColor: MyColor.danger400,
              ),
            ),

            SizedBox(
              width: AdaptSize.screenWidth * .008,
            ),

            /// user name & date post
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: AdaptSize.screenHeight * .004,
                  ),
                  Row(
                    children: [
                      ///name
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(
                          '$userNameReview ',
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(fontSize: AdaptSize.pixel14),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),

                      Icon(
                        Icons.brightness_1,
                        size: AdaptSize.pixel4,
                        color: MyColor.neutral600,
                      ),

                      /// date post
                      Text(
                        ' $dateReview',
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              fontSize: AdaptSize.pixel14,
                              color: MyColor.neutral600,
                            ),
                        maxLines: 1,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: AdaptSize.pixel18,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: reviewStarLength,
                        itemBuilder: (context, index) {
                          return Icon(
                            Icons.star,
                            color: HexColor('E5D11A'),
                            size: AdaptSize.pixel16,
                          );
                        }),
                  )
                ],
              ),
            )
          ],
        ),

        SizedBox(
          height: AdaptSize.pixel10,
        ),

        /// description
        Text(
          descriptionReview,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                fontSize: AdaptSize.pixel14,
              ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),

        const Spacer(),

        /// helpfull button
        Container(
          width: AdaptSize.screenHeight / 1000 * 150,
          padding: EdgeInsets.all(AdaptSize.screenHeight * .008),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: MyColor.neutral200),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              /// icon button
              InkWell(
                splashColor: MyColor.transparanColor,
                onTap: buttonHelpful,
                child: Icon(
                  Icons.thumb_up_alt_outlined,
                  size: AdaptSize.pixel14,
                ),
              ),

              SizedBox(
                width: AdaptSize.pixel4,
              ),

              /// helpfull text
              Text(
                'Helpfull ($totalHelpful)',
                style: Theme.of(context)
                    .textTheme
                    .subtitle2!
                    .copyWith(fontSize: AdaptSize.pixel10),
              )
            ],
          ),
        ),
      ],
    ),
  );
}

Widget buildRatingStar(int index, double currentRating) {
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
