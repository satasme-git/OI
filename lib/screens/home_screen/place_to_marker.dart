import 'dart:ui' as ui;


import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/place_model.dart';
import 'custom_markers.dart';

Future<BitmapDescriptor> placeToMarker(Place place) async {
  final recoder = ui.PictureRecorder();
  final canvas = ui.Canvas(recoder);
  const size = ui.Size(380, 100);

  final customMarker = MyCustomMarker(
    label: place.address!,
    duration: 15,
  );
  customMarker.paint(canvas, size);
  final picture = recoder.endRecording();
  final image = await picture.toImage(
    size.width.toInt(),
    size.height.toInt(),
  );
  final byteData = await image.toByteData(
    format: ui.ImageByteFormat.png,
  );

  final bytes = byteData!.buffer.asUint8List();
  return BitmapDescriptor.fromBytes(bytes);
}
