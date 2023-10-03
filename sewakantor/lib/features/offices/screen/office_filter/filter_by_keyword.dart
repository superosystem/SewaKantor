import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sewakantor/core/network/network_aware.dart';
import 'package:sewakantor/core/network/no_connection_screen.dart';
import 'package:sewakantor/features/home/widget/search_field.dart';
import 'package:sewakantor/features/locations/view_model/get_location_view_model.dart';
import 'package:sewakantor/features/navigation/view_model/navigasi_view_model.dart';
import 'package:sewakantor/features/offices/widget/office_type_card.dart';
import 'package:sewakantor/features/spaces/view_model/search_spaces_view_model.dart';
import 'package:sewakantor/utils/adapt_size.dart';
import 'package:sewakantor/utils/colors.dart';
import 'package:sewakantor/utils/remove_trailing_zero.dart';

class KeywordFilterScreen extends StatefulWidget {
  const KeywordFilterScreen({Key? key}) : super(key: key);

  @override
  State<KeywordFilterScreen> createState() => _KeywordFilterScreenState();
}

class _KeywordFilterScreenState extends State<KeywordFilterScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final searchFilter =
        Provider.of<SearchSpacesViewModel>(context, listen: false);
    searchFilter.officeListFilter = searchFilter.foundOffice;
    Future.delayed(Duration.zero, () {
      searchFilter.filterAllOffice(context, _searchController.text);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider =
        Provider.of<GetLocationViewModel>(context, listen: false);
    return Scaffold(
      body: NetworkAware(
        offlineChild: const NoConnectionScreen(),
        onlineChild:
            Consumer<SearchSpacesViewModel>(builder: (context, values, child) {
          return Padding(
            padding: EdgeInsets.only(
              left: AdaptSize.screenWidth * .016,
              right: AdaptSize.screenWidth * .016,
              top: AdaptSize.paddingTop + 3,
            ),
            child: Column(
              children: [
                /// text field
                searchPlace(
                  /// search keyword
                  context: context,
                  margin: EdgeInsets.only(
                    bottom: AdaptSize.screenHeight * .016,
                  ),
                  hintText: 'Type keyword...',
                  controller: _searchController,
                  onChanged: (value) => values.filterAllOffice(context, value!),
                  prefixIcon: IconButton(
                    onPressed: () {
                      context.read<NavigasiViewModel>().navigasiPop(context);
                    },
                    splashColor: MyColor.neutral900,
                    icon: Icon(
                      Icons.arrow_back,
                      color: MyColor.darkColor.withOpacity(.8),
                      size: AdaptSize.pixel22,
                    ),
                  ),
                  suffixIcon: Icon(
                    Icons.search,
                    color: MyColor.neutral600,
                    size: AdaptSize.pixel22,
                  ),
                  readOnly: false,
                ),

                /// content
                Expanded(
                  child: values.foundOffice.isNotEmpty
                      ? MediaQuery.removePadding(
                          removeTop: true,
                          context: context,
                          child: ListView.builder(
                            itemCount: values.foundOffice.length,
                            itemBuilder: (context, index) => Card(
                              key: ValueKey(
                                  values.foundOffice[index].officeName),
                              color: MyColor.neutral900,
                              elevation: 0,
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              child: officeTypeItemCards(
                                context: context,
                                onTap: () {
                                  context
                                      .read<NavigasiViewModel>()
                                      .navigasiToDetailSpace(
                                        context: context,
                                        officeId:
                                            values.foundOffice[index].officeID,
                                      );
                                },
                                officeImage:
                                    values.foundOffice[index].officeLeadImage,
                                officeName:
                                    values.foundOffice[index].officeName,
                                officeLocation:
                                    '${values.foundOffice[index].officeLocation.district}, ${values.foundOffice[index].officeLocation.city}',
                                officeStarRanting: values
                                    .foundOffice[index].officeStarRating
                                    .toString(),
                                officeApproxDistance:
                                    locationProvider.posisi != null
                                        ? locationProvider
                                            .homeScreenCalculateDistances(
                                                locationProvider.lat!,
                                                locationProvider.lng!,
                                                values
                                                    .foundOffice[index]
                                                    .officeLocation
                                                    .officeLatitude,
                                                values
                                                    .foundOffice[index]
                                                    .officeLocation
                                                    .officeLongitude)!
                                        : '-',
                                officePersonCapacity: values
                                    .foundOffice[index].officePersonCapacity
                                    .toString()
                                    .replaceAll(RemoveTrailingZero.regex, ''),
                                officeArea: values.foundOffice[index].officeArea
                                    .toString()
                                    .replaceAll(RemoveTrailingZero.regex, ''),
                                officeType:
                                    values.foundOffice[index].officeType,
                              ),
                            ),
                          ),
                        )
                      : Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/image_assets/search_empty.png',
                                height: AdaptSize.screenWidth / 2,
                                width: AdaptSize.screenWidth / 2,
                              ),
                              SizedBox(
                                height: AdaptSize.screenHeight * .012,
                              ),
                              Text(
                                'Where do you want to work ?',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(fontSize: AdaptSize.pixel15),
                              ),
                              SizedBox(
                                height: AdaptSize.screenHeight * .01,
                              ),
                              Text(
                                  'You can search for keywords by name, city, and office type (Coworking, Meeting Room or    Office Building)',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(fontSize: AdaptSize.pixel14))
                            ],
                          ),
                        ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget searchContent({
    required String image,
    required String name,
    required String location,
    required String buildingArea,
    required String category,
    required int totalBooking,
    required double officeRanting,
  }) {
    return SizedBox(
      height: AdaptSize.screenWidth / 2800 * 2000,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          children: [
            /// space image
            Stack(
              children: [
                /// image space
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    image,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 8,
                  child: Stack(
                    children: [
                      /// ranting
                      Container(
                        height: AdaptSize.screenHeight * .028,
                        width: AdaptSize.screenHeight * .06,
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
                              size: AdaptSize.screenHeight * 0.02,
                            ),
                            Text(
                              '$officeRanting',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
                                      color: MyColor.whiteColor,
                                      fontSize: AdaptSize.screenHeight * 0.014),
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
              width: AdaptSize.screenWidth * .01,
            ),

            /// keterangan
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(fontSize: AdaptSize.pixel16),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  /// jarak bawah
                  SizedBox(
                    height: AdaptSize.screenHeight * .008,
                  ),

                  /// lokasi
                  Text(
                    location,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontSize: AdaptSize.pixel14),
                  ),

                  /// jarak bawah
                  SizedBox(
                    height: AdaptSize.screenHeight * .008,
                  ),

                  /// icon keterangan
                  Flexible(
                    child: Row(
                      children: [
                        /// icon lokasi
                        Icon(
                          Icons.location_on_outlined,
                          size: AdaptSize.pixel22,
                        ),

                        const SizedBox(
                          width: 1,
                        ),

                        /// keterangan lokasi
                        Text(
                          '50m',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(
                                  fontSize: AdaptSize.screenHeight * .014),
                        ),

                        SizedBox(
                          width: AdaptSize.screenHeight * .008,
                        ),

                        /// total person asset
                        SvgPicture.asset(
                          'assets/svg_assets/available.svg',
                          height: AdaptSize.screenHeight * .025,
                        ),

                        const SizedBox(
                          width: 1,
                        ),

                        /// total person
                        Text(
                          '$totalBooking',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(
                                  fontSize: AdaptSize.screenHeight * .014),
                        ),

                        SizedBox(
                          width: AdaptSize.screenHeight * .008,
                        ),

                        /// icon penggaris
                        SvgPicture.asset(
                          'assets/svg_assets/ruler.svg',
                          height: AdaptSize.screenHeight * .025,
                        ),

                        const SizedBox(
                          width: 1,
                        ),

                        /// jarak lokasi
                        Text(
                          buildingArea,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(
                                  fontSize: AdaptSize.screenHeight * .014),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),

                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: MyColor.primary700,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.5),
                      child: Text(
                        category,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: MyColor.primary700,
                            fontSize: AdaptSize.screenHeight * .014),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
