import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:logger/logger.dart';
import 'package:oi/controller/location_controller.dart';
import '../../models/place_model.dart';
import '../../screens/home_screen/place_to_marker.dart';

class LocationProvider extends ChangeNotifier {
  Map<String, Marker> marker = {};
  Map<String, Marker> markerOrigin = {};
  late Place _placeModel;

  Place? _pick;
  final LocationController _locationController = LocationController();
  //check curreant location is set
  double _currentlocationlatitude = 0.0;

  String _pickLocationfocus = "";
  String get pickLocationfocus => _pickLocationfocus;

  Place? get getPick => _pick;

  double get getCurentLocationisSet => _currentlocationlatitude;

  Map<String, Marker> get markers => marker;
  Map<String, Marker> get markersOrigin => markerOrigin;

  void setFocus(String val) {
    _pickLocationfocus = val;

    Logger().i(">>>>>>>>>>>>>>>>>>>>>>>>>>>>> UUUUUU : " + val);
    notifyListeners();
  }

  void setLatitude(double latitude) {
    _currentlocationlatitude = latitude;
    notifyListeners();
  }

  void setSinglePlace(Place model) {
    _placeModel = model;
    notifyListeners();
  }

  Future<void> startAddPlace(PickResult result) async {
    Place place = await _locationController.savePlaceData(
      result.placeId!,
      result.formattedAddress!,
      result.geometry!.location.lat,
      result.geometry!.location.lng,
    );

    if (_pickLocationfocus == "pick") {
      _pick = place;
    }

    marker = await _locationController.addMarkers(_pickLocationfocus, place);

    var originIcon = await customPin();
    markerOrigin['pick'] = Marker(
      markerId: MarkerId("pick"),
      position: place.position!,
      icon: originIcon,
      anchor: Offset(0.5, 1.2),
    );


    notifyListeners();
  }

  Future<void> currentLocationAddPlace(LatLng latLng) async {
    Place place = await _locationController.savePlaceData(
      "1",
      "You Locations",
      latLng.latitude,
      latLng.longitude,
    );
    if (_pickLocationfocus == "pick") {
      _placeModel = place;
    }

    // marker = await _locationController.addMarkers(_pickLocationfocus, place);
    var originIcon = await customPin();
    markerOrigin['pick'] = Marker(
      markerId: MarkerId("pick"),
      position: place.position!,
      icon: originIcon,
      anchor: Offset(0.29, 1.2),
    );

    notifyListeners();
  }
}
