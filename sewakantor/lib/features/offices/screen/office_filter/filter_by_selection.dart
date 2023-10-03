import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sewakantor/core/network/network_aware.dart';
import 'package:sewakantor/core/network/no_connection_screen.dart';
import 'package:sewakantor/features/locations/view_model/get_location_view_model.dart';
import 'package:sewakantor/features/navigation/view_model/navigasi_view_model.dart';
import 'package:sewakantor/features/offices/widget/horizontal_card_home.dart';
import 'package:sewakantor/features/spaces/view_model/search_spaces_view_model.dart';
import 'package:sewakantor/utils/adapt_size.dart';
import 'package:sewakantor/utils/colors.dart';
import 'package:sewakantor/utils/remove_trailing_zero.dart';
import 'package:sewakantor/widgets/default_appbar_widget.dart';

class SelectedFilterScreen extends StatefulWidget {
  final String officeLocation;
  final String officeType;
  final String? dateSelected;

  const SelectedFilterScreen({
    Key? key,
    required this.officeLocation,
    required this.officeType,
    this.dateSelected,
  }) : super(key: key);

  @override
  State<SelectedFilterScreen> createState() => _SelectedFilterScreenState();
}

class _SelectedFilterScreenState extends State<SelectedFilterScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final searchFilter =
        Provider.of<SearchSpacesViewModel>(context, listen: false);
    searchFilter.officeFilterBySelecting =
        searchFilter.foundAllOfficeBySelecting;
    Future.delayed(Duration.zero, () {
      searchFilter.filterAllOfficeBySelecting(
          context, widget.officeLocation, widget.officeType);
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
      appBar: defaultAppbarWidget(
        contexts: context,
        titles: 'Where do you want to work today?',
        leadIconFunction: () {
          context.read<NavigasiViewModel>().navigasiPop(context);
        },
        isCenterTitle: false,
      ),
      body: NetworkAware(
        offlineChild: const NoConnectionScreen(),
        onlineChild:
            Consumer<SearchSpacesViewModel>(builder: (context, values, child) {
          return values.foundAllOfficeBySelecting.isNotEmpty
              ? MediaQuery.removePadding(
                  removeTop: true,
                  context: context,
                  child: Stack(
                    children: [
                      ///dibalik

                      /// search content
                      Padding(
                        padding: EdgeInsets.only(
                            top: AdaptSize.screenWidth / 1000 * 100,
                            right: AdaptSize.screenWidth * .016,
                            left: AdaptSize.screenWidth * .016),
                        child: ListView.builder(
                          itemCount: values.foundAllOfficeBySelecting.length,
                          itemBuilder: (context, index) => Card(
                            key: ValueKey(values
                                .foundAllOfficeBySelecting[index].officeName),
                            color: MyColor.neutral900,
                            elevation: 0,
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            child: horizontalCardHome(
                              context: context,
                              onTap: () {
                                context
                                    .read<NavigasiViewModel>()
                                    .navigasiToDetailSpace(
                                      context: context,
                                      officeId: values
                                          .foundAllOfficeBySelecting[index]
                                          .officeID,
                                    );
                              },
                              officeImage: values
                                  .foundAllOfficeBySelecting[index]
                                  .officeLeadImage,
                              officeName: values
                                  .foundAllOfficeBySelecting[index].officeName,
                              officeLocation:
                                  '${values.foundAllOfficeBySelecting[index].officeLocation.district}, ${values.foundAllOfficeBySelecting[index].officeLocation.city}',
                              officeStarRanting: values
                                  .foundAllOfficeBySelecting[index]
                                  .officeStarRating
                                  .toString(),
                              officeApproxDistance: locationProvider.posisi !=
                                      null
                                  ? locationProvider
                                      .homeScreenCalculateDistances(
                                          locationProvider.lat!,
                                          locationProvider.lng!,
                                          values
                                              .foundAllOfficeBySelecting[index]
                                              .officeLocation
                                              .officeLatitude,
                                          values
                                              .foundAllOfficeBySelecting[index]
                                              .officeLocation
                                              .officeLongitude)!
                                  : '-',
                              officePersonCapacity: values
                                  .foundAllOfficeBySelecting[index]
                                  .officePersonCapacity
                                  .toString()
                                  .replaceAll(RemoveTrailingZero.regex, ''),
                              officeArea: values
                                  .foundAllOfficeBySelecting[index].officeArea
                                  .toString()
                                  .replaceAll(RemoveTrailingZero.regex, ''),
                              hours: values.foundAllOfficeBySelecting[index]
                                          .officeType ==
                                      "Office"
                                  ? '/Month'
                                  : '/Hours',
                              officePricing: values
                                  .foundAllOfficeBySelecting[index]
                                  .officePricing
                                  .officePrice,
                            ),
                          ),
                        ),
                      ),

                      /// header chip
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          height: AdaptSize.screenWidth / 1000 * 100,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: MyColor.neutral900,
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(1, 1),
                                color: MyColor.neutral700,
                                blurRadius: 2,
                              )
                            ],
                          ),
                          child: Stack(
                            children: [
                              /// list of filtering value
                              Padding(
                                padding: EdgeInsets.only(
                                    left: AdaptSize.screenWidth / 1000 * 95),
                                child: ListView(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    Chip(
                                      label: Text(
                                        widget.officeType,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                              fontSize: AdaptSize.pixel12,
                                            ),
                                      ),
                                      backgroundColor: MyColor.secondary950,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        side: BorderSide(
                                          color: MyColor.secondary700,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: AdaptSize.screenWidth * .010,
                                    ),
                                    Chip(
                                      label: Text(
                                        widget.officeLocation,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                              fontSize: AdaptSize.pixel12,
                                            ),
                                      ),
                                      backgroundColor: MyColor.secondary950,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        side: BorderSide(
                                          color: MyColor.secondary700,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: AdaptSize.screenWidth * .010,
                                    ),
                                    Chip(
                                      label: Text(
                                        widget.dateSelected!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                              fontSize: AdaptSize.pixel12,
                                            ),
                                      ),
                                      backgroundColor: MyColor.secondary950,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        side: BorderSide(
                                          color: MyColor.secondary700,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: AdaptSize.screenWidth * .010,
                                    ),
                                  ],
                                ),
                              ),

                              /// filter icon
                              Card(
                                color: MyColor.secondary900,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: SvgPicture.asset(
                                    'assets/svg_assets/mi_filter.svg',
                                    color: MyColor.secondary400,
                                    height: AdaptSize.screenWidth / 1000 * 50,
                                    width: AdaptSize.screenWidth / 1000 * 50,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/image_assets/close_up.png',
                        height: AdaptSize.screenWidth / 2,
                        width: AdaptSize.screenWidth / 2,
                      ),
                      SizedBox(
                        height: AdaptSize.screenHeight * .012,
                      ),
                      Text(
                        'Office not found',
                        style: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(fontSize: AdaptSize.pixel15),
                      ),
                      SizedBox(
                        height: AdaptSize.screenHeight * .01,
                      ),
                      Text(
                          'Sorry, the office you are looking for is not yet available',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontSize: AdaptSize.pixel14))
                    ],
                  ),
                );
        }),
      ),
    );
  }
}
