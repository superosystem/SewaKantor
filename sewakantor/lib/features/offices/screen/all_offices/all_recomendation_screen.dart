import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sewakantor/core/network/network_aware.dart';
import 'package:sewakantor/core/network/no_connection_screen.dart';
import 'package:sewakantor/data/model/offices/office_dummy_models.dart';
import 'package:sewakantor/features/locations/view_model/get_location_view_model.dart';
import 'package:sewakantor/features/navigation/view_model/navigasi_view_model.dart';
import 'package:sewakantor/features/offices/view_model/office_view_models.dart';
import 'package:sewakantor/features/offices/widget/horizontal_card_home.dart';
import 'package:sewakantor/utils/adapt_size.dart';
import 'package:sewakantor/utils/remove_trailing_zero.dart';
import 'package:sewakantor/widgets/default_appbar_widget.dart';

class AllRecomendationOfficeScreen extends StatelessWidget {
  const AllRecomendationOfficeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locationProvider =
        Provider.of<GetLocationViewModel>(context, listen: false);
    final officeListrecommendation =
        Provider.of<OfficeViewModels>(context, listen: false);
    officeListrecommendation.fetchOfficeByRecommendation();

    final officeListAlloffice =
        Provider.of<OfficeViewModels>(context, listen: true);

    List<OfficeModels> listOfRecomendationRoom =
        officeListAlloffice.listOfOfficeByRecommendation;

    return Scaffold(
      appBar: defaultAppbarWidget(
        contexts: context,
        titles: 'Recommendation',
        leadIconFunction: () {
          context.read<NavigasiViewModel>().navigasiPop(context);
        },
        isCenterTitle: false,
      ),
      body: NetworkAware(
        offlineChild: const NoConnectionScreen(),
        onlineChild: Padding(
          padding: EdgeInsets.only(
            left: AdaptSize.screenWidth * .016,
            right: AdaptSize.screenWidth * .016,
          ),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: listOfRecomendationRoom.length,
            physics: const ScrollPhysics(),
            itemBuilder: (context, index) {
              return horizontalCardHome(
                context: context,
                onTap: () {
                  context.read<NavigasiViewModel>().navigasiToDetailSpace(
                        context: context,
                        officeId: listOfRecomendationRoom[index].officeID,
                      );
                },
                officeImage: listOfRecomendationRoom[index].officeLeadImage,
                officeName: listOfRecomendationRoom[index].officeName,
                officeLocation:
                    '${listOfRecomendationRoom[index].officeLocation.district}, ${listOfRecomendationRoom[index].officeLocation.city}',
                officeStarRanting:
                    listOfRecomendationRoom[index].officeStarRating.toString(),
                officeApproxDistance: locationProvider.posisi != null
                    ? locationProvider.homeScreenCalculateDistances(
                        locationProvider.lat,
                        locationProvider.lng,
                        listOfRecomendationRoom[index]
                            .officeLocation
                            .officeLatitude,
                        listOfRecomendationRoom[index]
                            .officeLocation
                            .officeLongitude,
                      )!
                    : '-',
                officePersonCapacity: listOfRecomendationRoom[index]
                    .officePersonCapacity
                    .toString()
                    .replaceAll(RemoveTrailingZero.regex, ''),
                officeArea: listOfRecomendationRoom[index]
                    .officeArea
                    .toString()
                    .replaceAll(RemoveTrailingZero.regex, ''),
                hours: listOfRecomendationRoom[index].officeType == "Office"
                    ? '/Month'
                    : '/Hours',
                officePricing:
                    listOfRecomendationRoom[index].officePricing.officePrice,
              );
            },
          ),
        ),
      ),
    );
  }
}
