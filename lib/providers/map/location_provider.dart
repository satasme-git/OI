import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:logger/logger.dart';
import 'package:oi/controller/location_controller.dart';
import 'package:oi/models/objects.dart';
import 'package:provider/provider.dart';

import '../../models/place_model.dart';
import '../../screens/home_screen/vehicle_select_map/widgets/place_to_marker.dart';
import '../../utils/global_data.dart';
import '../auth/user_provider.dart';

class LocationProvider extends ChangeNotifier {
  Map<String, Marker> marker = {};
  Map<String, Marker> markerOrigin = {};

  Set<Polyline> _polylines = {};
  List<LatLng> polylineCoordinates = [];

  Set<Polyline> get getPolyline => _polylines;

  // late Place _placeModel;

  Place? _pick;
  final LocationController _locationController = LocationController();
  //check curreant location is set
  double _currentlocationlatitude = 0.0;

  String _pickLocationfocus = "";
  String get pickLocationfocus => _pickLocationfocus;

  Place? get getPick => _pick;

  double get getCurentLocationisSet => _currentlocationlatitude;

  double _distance = 0;
  double get getDistance => _distance;

  Map<String, Marker> get markers => marker;
  Map<String, Marker> get markersOrigin => markerOrigin;

  void setFocus(String val) {
    _pickLocationfocus = val;
    notifyListeners();
  }

  void setLatitude(double latitude) {
    _currentlocationlatitude = latitude;
    notifyListeners();
  }

  

// search from location selector
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

    addMarker(place);
    notifyListeners();
  }

// search from autocomplete
  Future<void> setAddressGeo(GeocodingResponse response) async {
    Place place = await _locationController.savePlaceData(
      response.results[0].placeId,
      response.results[0].formattedAddress!,
      response.results[0].geometry.location.lat,
      response.results[0].geometry.location.lng,
    );

    if (_pickLocationfocus == "pick") {
      _pick = place;
    }

    addMarker(place);
    notifyListeners();
  }

// add pick and drop markers
  Future<void> addMarker(Place place) async {
    marker = await _locationController.addMarkers(_pickLocationfocus, place);

//set pin marker for main map if it is pick
    var originIcon = await customPin();
    markerOrigin['pick'] = Marker(
      markerId: MarkerId("pick"),
      position: place.position!,
      icon: originIcon,
      anchor: Offset(0.5, 1.2),
    );

    notifyListeners();
  }

  Future<void> removeMarker() async {
    //  _polylines.removeAll({'polyline'});
    // _polylines = {};
    // polylineCoordinates = [];

     
    marker = await _locationController.removeMarkers();

    notifyListeners();
  }

/*load cuurent location with black  marker pin
pass latitude and longitude, then get location with location id and address, pass it into location controller, then return place object and asign it into Place,
*/
  Future<void> currentLocationAddPlace(LatLng latLng) async {
    final geocoding = GoogleMapsGeocoding(apiKey: GlobalData.API_key);
    final response = await geocoding.searchByLocation(
        Location(lat: latLng.latitude, lng: latLng.longitude));

    Place place = await _locationController.savePlaceData(
      response.results[0].placeId,
      response.results[0].formattedAddress!,
      latLng.latitude,
      latLng.longitude,
    );
    addMarker(place);
    if (_pickLocationfocus == "pick") {
      _pick = place;
    }

    notifyListeners();
  }

  Future<void> getPolyLineCodes(GoogleMapController controller) async {
    

    polylineCoordinates =
        await _locationController.getPolyLineCordinates(controller);

    _polylines.add(Polyline(
        polylineId: PolylineId('polyline'),
        width: 2,
        color: Colors.orange.shade800,
        points: polylineCoordinates));

    _distance = await _locationController.getDistance();

    // _polylines.forEach((value) => {
    //       print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ : " +
    //           value.points.toString())
    //     });

    // Logger().d(
    //     "#########################%% : " + _polylines.elementAt(0).toString());
    // Logger()
    //     .d("#########################)) : " + polylineCoordinates.toString());

    notifyListeners();
  }

  Future<void> startAddSelectedPlace(BuildContext context, String res) async {
    UserModel? _userModel =
        Provider.of<UserProvider>(context, listen: false).getuserModel;

    Place place = await _locationController.savePlaceData(
      "4",
      res == "home"
          ? _userModel!.homeaddress!.addressString
          : _userModel!.workaddress!.addressString,
      res == "home"
          ? _userModel.homeaddress!.latitude
          : _userModel.workaddress!.latitude,
      res == "home"
          ? _userModel.homeaddress!.longitude
          : _userModel.workaddress!.longitude,
    );

    if (_pickLocationfocus == "pick") {
      _pick = place;
    }

    addMarker(place);
    notifyListeners();
  }
}
