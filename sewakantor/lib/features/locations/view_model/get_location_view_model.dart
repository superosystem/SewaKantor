import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart' as poly;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sewakantor/data/model/offices/office_dummy_models.dart';
import 'package:sewakantor/data/remote/constant.dart';
import 'package:sewakantor/features/navigation/view_model/navigasi_view_model.dart';
import 'package:sewakantor/utils/colors.dart';
import 'package:sewakantor/widgets/dialog/custom_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class GetLocationViewModel with ChangeNotifier {
  String text1 = 'Allow ';
  String text2 = 'Better Space App ';
  String text3 =
      'requires permission to access your phone\'s location, used to Calculate the distance of the office from your current position';
  Position? posisi;

  late double? lat;

  late double? lng;

  LocationPermission? locationPermission;

  /// permission lokasi chekker
  Future checkAndGetPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    posisi = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    if (posisi != null) {
      lat = posisi?.latitude;
      lng = posisi?.longitude;
    }
  }

  /// permission lokasi chekker
  Future permissionLocationGMap(context, OfficeModels officeId) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return CustomDialog.singleActionDialogWithoutImage(
          context: context,
          title: 'text permission',
          text1: text1,
          text2: text2,
          text3: text3,
          withTextRich: true,
          onPressed: () async {
            Provider.of<NavigasiViewModel>(context, listen: false)
                .navigasiPop(context);
            await Geolocator.openLocationSettings();
          });
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return CustomDialog.singleActionDialogWithoutImage(
            context: context,
            title: 'text permission',
            withTextRich: true,
            text1: text1,
            text2: text2,
            text3: text3,
            onPressed: () async {
              Provider.of<NavigasiViewModel>(context, listen: false)
                  .navigasiPop(context);
              await GeolocatorPlatform.instance.requestPermission();
            });
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return CustomDialog.singleActionDialogWithoutImage(
          context: context,
          withTextRich: true,
          text1: text1,
          text2: text2,
          text3: text3,
          title: 'text permission',
          onPressed: () async {
            Provider.of<NavigasiViewModel>(context, listen: false)
                .navigasiPop(context);
            await GeolocatorPlatform.instance.requestPermission();
            await Geolocator.openLocationSettings();
          });
    }
    posisi = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    if (posisi != null) {
      lat = posisi?.latitude;
      lng = posisi?.longitude;
    }

    if (serviceEnabled) {
      await getAddressFromLongLat(posisi!.latitude, posisi!.longitude);
      Provider.of<NavigasiViewModel>(context, listen: false)
          .navigasiOpenGoogleMaps(context: context, officeId: officeId);
    }
  }

  /// ------------------------------------------------------------------------
  /// feature google maps

  Map<PolylineId, Polyline> polylines = {};
  Map<MarkerId, Marker> markers = {};
  List<LatLng> polylineCoordinates = [];
  final Completer<GoogleMapController> controllerMaps = Completer();
  late String address;

  /// polyline
  Future<void> createPolylines({
    required LatLng destinationCoordinates,
  }) async {
    polylineCoordinates.clear();
    polylines.clear();

    poly.PolylinePoints polylinePoints = poly.PolylinePoints();
    poly.PolylineResult result = await polylinePoints
        .getRouteBetweenCoordinates(
      constantValue().gmapApiKey,
      poly.PointLatLng(
        posisi!.latitude,
        posisi!.longitude,
      ),
      poly.PointLatLng(
        destinationCoordinates.latitude,
        destinationCoordinates.longitude,
      ),
      optimizeWaypoints: true,
    )
        .catchError((e) {
      debugPrint(e);
    });
    notifyListeners();

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }

    /// polyline id
    PolylineId id = const PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: MyColor.secondary400,
      points: polylineCoordinates,
      width: 4,
    );
    polylines[id] = polyline;
  }

  /// destination marker
  void addMarker({
    required double destinationLat,
    required double destinationLng,
    required String id,
    required BitmapDescriptor descriptor,
  }) {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(
      markerId: markerId,
      icon: descriptor,
      position: LatLng(
        destinationLat,
        destinationLng,
      ),
    );
    markers[markerId] = marker;
    notifyListeners();
  }

  /// string calculate distance
  String? calculateDistances(posLat, posLng, desLat, desLng) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((desLat - posLat) * p) / 2 +
        c(posLat * p) * c(desLat * p) * (1 - c((desLng - posLng) * p)) / 2;
    var dis = 12742 * asin(sqrt(a));
    return dis < 1
        ? "${(double.parse(dis.toStringAsFixed(3)) * 1000).toString().split(".")[0]}m"
        : "${double.parse(dis.toStringAsFixed(2))}km";
  }

  /// string calculate distance in home
  String? homeScreenCalculateDistances(posLat, posLng, desLat, desLng) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((desLat - posLat) * p) / 2 +
        c(posLat * p) * c(desLat * p) * (1 - c((desLng - posLng) * p)) / 2;
    var dis = 12742 * asin(sqrt(a));
    return dis < 1
        ? "${(double.parse(dis.toStringAsFixed(3)) * 1000).toString().split(".")[0]}m"
        : "${double.parse(dis.toStringAsFixed(1))}km";
  }

  /// detail lokasi
  Future<void> getAddressFromLongLat(double posLat, double posLong) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(posLat, posLong);
    Placemark place = placemarks[0];
    address =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    notifyListeners();
  }

  /// launch google maps external
  Future<void> launchGMap({
    required double posLat,
    required double posLng,
  }) async {
    if (!await launchUrl(
      Uri.parse(
          'https://www.google.com/maps/search/?api=1&query=$posLat,$posLng'),
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch';
    }
  }
}
