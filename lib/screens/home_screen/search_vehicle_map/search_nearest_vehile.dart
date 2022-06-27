import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class SearchNearestVehicle extends StatefulWidget {
  static const CameraPosition _locationColombo = CameraPosition(
    target: LatLng(6.927079, 79.861244),
    bearing: 92.8334901395799,
    zoom: 16,
  );

  const SearchNearestVehicle({Key? key}) : super(key: key);

  @override
  State<SearchNearestVehicle> createState() => _SearchNearestVehicleState();
}

class _SearchNearestVehicleState extends State<SearchNearestVehicle> {
   bool _mapLoading = true;
  GoogleMapController? controller;
  final Completer<GoogleMapController> _controller = Completer();
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      
      child: Stack(
  children: <Widget>[
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(37.4220, -122.0841),
              zoom: 15,
            ),
            onMapCreated: (GoogleMapController controller) =>
                setState(() => _mapLoading = false),
          ),
          (_mapLoading)
              ? Container(
                  height: size.height,
                  width: size.width,
                  color: Colors.grey[100],
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Container(),
        ],
      ),
      // GoogleMap(
      //   myLocationButtonEnabled: false,
      //   compassEnabled: false,
      //   mapToolbarEnabled: false,
      //   myLocationEnabled: true,
      //   mapType: MapType.normal,
      //   zoomControlsEnabled: false,
      //   zoomGesturesEnabled: true,
      //   initialCameraPosition: SearchNearestVehicle._locationColombo,
      //   onMapCreated: (controller) async {
      //     _controller.complete(controller);

      //     // String value = _isNight_map
      //     //     ? await DefaultAssetBundle.of(context).loadString(
      //     //         'assets/map_styles/map_style.json')
      //     //     : await DefaultAssetBundle.of(context).loadString(
      //     //         'assets/map_styles/map_style_night.json');

      //     // controller.setMapStyle(value);

      //     // values.setFocus("pick");
      //     // _goToTheLake(values.getPick?.position?.latitude,
      //     //     values.getPick?.position?.longitude);
      //   },
      // ),
    );
  }

  Future<void> _goToTheLake(lat, long) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    // currentLatitude = position.latitude;

    LatLng latLngPosition = LatLng(
      lat != null ? lat : position.latitude,
      long != null ? long : position.longitude,
    );
    CameraPosition cameraPosition = CameraPosition(
      // bearing: 92.8334901395799,
      target: latLngPosition,
      // tilt: 59.440717697143555,
      zoom: 14.151926040649414,
    );
    final GoogleMapController controller = await _controller.future;
  }
}
