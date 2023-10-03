import 'package:flutter/material.dart';
import 'package:sewakantor/utils/adapt_size.dart';
import 'package:sewakantor/utils/colors.dart';

Widget whistListCard({
  context,
  required ImageProvider<Object> officeImage,
  required String officeRanting,
  required String officeType,
  required String officeName,
  required String officeLocation,
  Function()? cardOnTap,
  Function()? bookmarkOntap,
}) {
  return InkWell(
    onTap: cardOnTap,
    child: Container(
      height: AdaptSize.screenWidth / 1000 * 340,
      width: double.infinity,
      margin: EdgeInsets.only(
        bottom: AdaptSize.screenHeight * .008,
      ),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: MyColor.whiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            offset: const Offset(1, 3),
            color: MyColor.grayLightColor.withOpacity(.4),
            blurRadius: 3,
          ),
        ],
      ),
      child: Row(
        children: [
          /// space image
          Stack(
            children: [
              Container(
                width: AdaptSize.screenWidth * .36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: officeImage,
                  ),
                ),
              ),
              Positioned(
                left: 10,
                top: 8,
                child: Stack(
                  children: [
                    /// ranting
                    Container(
                      height: AdaptSize.screenWidth / 1000 * 70,
                      width: AdaptSize.screenWidth / 1000 * 150,
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(
                          left: AdaptSize.screenHeight * .005,
                          right: AdaptSize.screenHeight * .005),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: MyColor.grayLightColor.withOpacity(.6),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: AdaptSize.pixel18,
                          ),
                          Text(
                            officeRanting,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(
                                    color: MyColor.whiteColor,
                                    fontSize: AdaptSize.pixel14),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          /// jarak samping
          SizedBox(
            width: AdaptSize.screenWidth * .008,
          ),

          /// keterangan
          Flexible(
            fit: FlexFit.loose,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      officeType,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontSize: AdaptSize.pixel14,
                            color: MyColor.neutral300,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    InkWell(
                      onTap: bookmarkOntap,
                      child: Icon(
                        Icons.bookmark,
                        size: AdaptSize.pixel22,
                        color: MyColor.secondary300,
                      ),
                    )
                  ],
                ),

                Text(
                  officeName,
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(fontSize: AdaptSize.pixel16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                /// jarak bawah
                SizedBox(
                  height: AdaptSize.screenHeight * .008,
                ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: AdaptSize.pixel22,
                    ),
                    SizedBox(
                      width: AdaptSize.pixel5,
                    ),

                    /// lokasi
                    Expanded(
                      child: Text(
                        officeLocation,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(fontSize: AdaptSize.pixel14),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                /// jarak bawah
                SizedBox(
                  height: AdaptSize.screenHeight * .008,
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}
