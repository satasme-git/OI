import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:oi/models/driver_model.dart';
import 'package:provider/provider.dart';
import '../models/place_model.dart';
import '../providers/map/location_provider.dart';
import '../screens/home_screen/vehicle_select_map/widgets/circle_marker.dart';
import '../screens/home_screen/vehicle_select_map/widgets/place_to_marker.dart';
import '../utils/fit_map.dart';
import '../utils/global_data.dart';

import 'package:rxdart/rxdart.dart';

class LocationController {
  final radius = BehaviorSubject<double>.seeded(100.0);
  final _firestore = FirebaseFirestore.instance;
  final markers = <MarkerId, Marker>{};
  late Stream<List<DocumentSnapshot>> stream;
  late Geoflutterfire geo;
  ////////////////////////////////////////////////////
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

  Future<Map<String, Marker>> removeMarkers() async {
    marker = {};
    // marker.values.forEach((Marker values) {
    //   if (values.markerId == MarkerId("pick")) {
    //     Logger().i("33333333333333333333333 : " + values.markerId.toString());
    //     marker.remove(Marker(markerId: MarkerId("pick")));
    //   }
    //   if (values.markerId == MarkerId("drop")) {
    //     marker.remove(Marker(markerId: MarkerId("drop")));
    //   }
    //   if (values.markerId == MarkerId("dropdot")) {
    //     marker.remove(Marker(markerId: MarkerId('dropdot')));
    //   }
    //   if (values.markerId == MarkerId("pickdot")) {
    //     marker.remove(Marker(markerId: MarkerId('pickdot')));
    //   }
    // });

    // marker.remove(MarkerId("drop"));

    return marker;
  }

  Future<Map<String, Marker>> addMarkers(String val, Place place) async {
    var originIcon;
    String markerId = "";
    String dot = "";
    if (val == "pick") {
      markerId = val;
      dot = "pickdot";
      originIcon = await placeToMarker(place, "Pick");

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

      originIcon = await placeToMarker(place, 'Drop');
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

  Future<double> getDistance() async {
    double distance = _originLatitude;

    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((_destLatitude - _originLatitude) * p) / 2 +
        cos(_originLatitude * p) *
            cos(_destLatitude * p) *
            (1 - cos((_destLongitude - _originLongitude) * p)) /
            2;

    distance = 12742 * asin(sqrt(a));
    return distance;
  }

  Future<List<LatLng>> getPolyLineCordinates(
      GoogleMapController controller) async {
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

    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      GlobalData.API_key,
      PointLatLng(_originLatitude, _originLongitude),
      PointLatLng(_destLatitude, _destLongitude),
      travelMode: TravelMode.driving,

      // wayPoints: [PolylineWayPoint(location: "Colombo, Sri Lanka")]
    );
    polylineCoordinates.clear();
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

  void addDriversMarker()  {
    geo = Geoflutterfire();
    GeoFirePoint center = geo.point(latitude: 6.9543, longitude: 80.2046);
    stream = radius.switchMap((rad) {
      final collectionReference =
          _firestore.collection('drivers').where('type', isEqualTo: '1');

      return geo.collection(collectionRef: collectionReference).within(
          center: center, radius: rad, field: 'position', strictMode: true);
    });

    stream.listen((List<DocumentSnapshot> documentList) {
      documentList.forEach((DocumentSnapshot document) async {
        final data = document.data() as Map<String, dynamic>;
        final GeoPoint point = data['position']['geopoint'];
        final id =
            MarkerId(point.latitude.toString() + point.longitude.toString());

        marker[id.toString()] = Marker(
          markerId: id,
          position: LatLng(point.latitude, point.longitude),
          icon: await BitmapDescriptor.fromAssetImage(
              ImageConfiguration(size: Size(2, 3)),
              "assets/images/car_map.png"),
          anchor: const Offset(0.5, 0.5),
        );
      });
    });
    
  }


}
