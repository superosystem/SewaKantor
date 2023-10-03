import 'dart:async';
import 'package:sewakantor/data/model/offices/office_dummy_models.dart';
import 'package:sewakantor/utils/adapt_size.dart';
import 'package:sewakantor/utils/colors.dart';
import 'package:sewakantor/features/locations/view_model/get_location_view_model.dart';
import 'package:sewakantor/features/navigation/view_model/navigasi_view_model.dart';
import 'package:sewakantor/widgets/bottom_detail_maps.dart';
import 'package:sewakantor/widgets/bottom_sheed_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class GoogleMapsWidget extends StatefulWidget {
  final OfficeModels officeData;

  const GoogleMapsWidget({super.key, required this.officeData});

  @override
  State<GoogleMapsWidget> createState() => _GoogleMapsWidgetState();
}

class _GoogleMapsWidgetState extends State<GoogleMapsWidget> {
  final Completer<GoogleMapController> controllerMaps = Completer();

  @override
  void initState() {
    super.initState();
    final mapsProviders =
        Provider.of<GetLocationViewModel>(context, listen: false);
    Future.delayed(Duration.zero, () {
      /// polylines
      mapsProviders.createPolylines(
        destinationCoordinates: LatLng(
          widget.officeData.officeLocation.officeLatitude,
          widget.officeData.officeLocation.officeLongitude,
        ),
      );

      /// marker
      mapsProviders.addMarker(
        destinationLat: widget.officeData.officeLocation.officeLatitude,
        destinationLng: widget.officeData.officeLocation.officeLongitude,
        id: widget.officeData.officeID,
        descriptor:
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<GetLocationViewModel>(builder: (context, value, child) {
          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(

                    /// target destination
                    target: LatLng(
                      widget.officeData.officeLocation.officeLatitude,
                      widget.officeData.officeLocation.officeLongitude,
                    ),
                    zoom: 11),
                myLocationEnabled: true,
                tiltGesturesEnabled: true,
                compassEnabled: true,
                indoorViewEnabled: true,
                scrollGesturesEnabled: true,
                zoomGesturesEnabled: true,
                onMapCreated: (GoogleMapController controller) {
                  value.controllerMaps.complete(controller);
                },
                zoomControlsEnabled: true,
                markers: Set<Marker>.of(value.markers.values),
                polylines: Set<Polyline>.of(value.polylines.values),
              ),
              Positioned(
                left: 10,
                top: 10,
                child: GestureDetector(
                  onTap: () {
                    context.read<NavigasiViewModel>().navigasiPop(context);
                  },
                  child: Container(
                    height: AdaptSize.screenWidth / 1000 * 100,
                    width: AdaptSize.screenWidth / 1000 * 100,
                    decoration: BoxDecoration(
                      color: MyColor.neutral800,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(1, 2),
                          blurRadius: 3,
                          color: MyColor.neutral600,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      size: AdaptSize.pixel20,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: MyColor.neutral900,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(1, 1),
                        color: MyColor.neutral400,
                        blurRadius: 2,
                        blurStyle: BlurStyle.solid,
                      ),
                    ],
                  ),
                  child: bottomDetailMaps(
                      context: context,
                      userAddress: value.address,
                      officeAddress:
                          '${widget.officeData.officeLocation.district}, ${widget.officeData.officeLocation.city}',
                      distance: value.posisi != null
                          ? value.calculateDistances(
                              value.lat,
                              value.lng,
                              widget.officeData.officeLocation.officeLatitude,
                              widget.officeData.officeLocation.officeLongitude)!
                          : '-',
                      onPressed: () {
                        /// confirm maps bottom sheed
                        modalBottomSheed(
                          context,
                          goToGMaps(
                              context: context,
                              onPressed: () {
                                value.launchGMap(
                                    posLat: widget.officeData.officeLocation
                                        .officeLatitude,
                                    posLng: widget.officeData.officeLocation
                                        .officeLongitude);
                              }),
                        );
                      }),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
