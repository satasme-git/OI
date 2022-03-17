import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' as math;

CameraUpdate fitMap(
  double originlat,
  double originlng,
  double destinationlat,
  double destinationlng, {
  double padding = 20,
}) {
  final left = math.min(originlat, destinationlat);
  final right = math.max(originlat, destinationlat);
  final top = math.min(originlng, destinationlng);
  final bottom = math.max(originlng, destinationlng);

  final bounds = LatLngBounds(
    southwest: LatLng(left, top),
    northeast: LatLng(right, bottom),
  );

  return CameraUpdate.newLatLngBounds(
    bounds,
    padding,
  );
}
