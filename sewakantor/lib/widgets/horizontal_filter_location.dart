import 'package:sewakantor/utils/adapt_size.dart';
import 'package:sewakantor/utils/colors.dart';
import 'package:flutter/material.dart';

/// update 13 12 22
/// mengubah border radius, background warna dan warna border
dynamic horizontalFilterLocation({
  required BuildContext contexts,
  required ValueNotifier<String> isSelected,
}) {
  AdaptSize.size(context: contexts);
  return ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: locationOffice.length,
    itemBuilder: ((context, index) {
      return ValueListenableBuilder(
        valueListenable: isSelected,
        builder: ((context, value, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  isSelected.value = locationOffice[index];
                },
                child: Container(
                  height: AdaptSize.screenWidth / 1000 * 300,
                  width: AdaptSize.screenWidth / 1000 * 300,
                  margin: EdgeInsets.all(AdaptSize.pixel8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      opacity:
                          isSelected.value == locationOffice[index] ? .6 : .9,
                      fit: BoxFit.cover,
                      image: const AssetImage(
                          'assets/image_assets/image_maps.png'),
                    ),
                    color: isSelected.value == locationOffice[index]
                        ? MyColor.secondary600
                        : MyColor.neutral400,
                    border: Border.all(
                      color: isSelected.value == locationOffice[index]
                          ? MyColor.secondary400
                          : MyColor.neutral900,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: AdaptSize.pixel10),
                child: Text(
                  locationOffice[index],
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        fontSize: AdaptSize.screenHeight * 0.016,
                      ),
                ),
              ),
            ],
          );
        }),
      );
    }),
  );
}

List<String> locationOffice = [
  'South Jakarta',
  'West Jakarta',
  'Central Jakarta',
  'East Jakarta',
];
