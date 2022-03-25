import 'dart:ui';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import '../models/place_model.dart';

import '../screens/home_screen/vehicle_select_map/widgets/circle_marker.dart';
import '../screens/home_screen/vehicle_select_map/widgets/place_to_marker.dart';
import '../utils/fit_map.dart';
import '../utils/global_data.dart';

class LocationController {
  PolylinePoints polylinePoints = PolylinePoints();
  Map<String, Marker> marker = {};
  List<LatLng> polylineCoordinates = [];

  BitmapDescriptor? _dotMarker;
  var originDot;

  double _originLatitude = 0.0,
      _originLongitude = 0.0,
      _destLatitude = 0.0,
      _destLongitude = 0.0;

  Future<Place> savePlaceData(
      String id, String address, double lat, double lng) async {
    Place placemodel = Place();

    placemodel.id = id;
    placemodel.address = address;
    placemodel.position = LatLng(lat, lng);

    
    return placemodel;
  }

  Future<Map<String, Marker>> addMarkers(String val, Place place) async {
    var originIcon;
    String markerId = "";
    String dot = "";
    if (val == "pick") {
      markerId = val;
      dot = "pickdot";
      originIcon = await placeToMarker(place,"Pick");

      _dotMarker = await getDotMarker();

      marker[dot] = Marker(
        markerId: MarkerId(dot),
        position: place.position!,
        icon: _dotMarker!,
        anchor: const Offset(0.5, 0.5),
      );
    } else if (val == "drop") {

   
      dot = "dropdot";
      marker[dot] = Marker(
        markerId: MarkerId(dot),
        position: place.position!,
        icon: _dotMarker!,
        anchor: const Offset(0.5, 0.5),
      );

      originIcon = await placeToMarker(place,'Drop');
      markerId = val;
    }
    marker[markerId] = Marker(
      markerId: MarkerId(markerId),
      position: place.position!,
      icon: originIcon,
      anchor: Offset(0.5, 1.2),
    );
    return marker;
  }

  Future<List<LatLng>> addPolyLines(GoogleMapController controller) async {
    marker.values.forEach((Marker values) {
      if (values.markerId == MarkerId("pick")) {
        _originLatitude = values.position.latitude;
        _originLongitude = values.position.longitude;
      }
      if (values.markerId == MarkerId("drop")) {
        _destLatitude = values.position.latitude;
        _destLongitude = values.position.longitude;
      }
    });

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      GlobalData.API_key,
      PointLatLng(_originLatitude, _originLongitude),
      PointLatLng(_destLatitude, _destLongitude),
      travelMode: TravelMode.driving,

      // wayPoints: [PolylineWayPoint(location: "Colombo, Sri Lanka")]
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        // return polylineCoordinates;
      });
    }

    await controller.animateCamera(
      fitMap(
        _originLatitude,
        _originLongitude,
        _destLatitude,
        _destLongitude,
        padding: 100,
      ),
    );
    return polylineCoordinates;
  }
}
