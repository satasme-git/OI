import 'dart:ui';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:oi/screens/home_screen/vehicle_select_map/widgets/custom_pin.dart';

import '../models/place_model.dart';
import '../screens/home_screen/place_to_marker.dart';

class LocationController {
  Map<String, Marker> marker = {};
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
    if (val == "pick") {
      markerId = val;
      originIcon = await  placeToMarker(place);
      Logger().i("~~~~~~~~~~~~~~~~~~~~~ 1 : " + markerId);
      
    } else if (val == "drop") {
      originIcon = await placeToMarker(place);
      markerId = val;
      Logger().i("******************** 2 : " + markerId);

      
    }
    marker[markerId] = Marker(
      markerId: MarkerId(markerId),
      position: place.position!,
      icon: originIcon,
      anchor: Offset(0.5, 1.2),
    );
    return marker;
  }
}
