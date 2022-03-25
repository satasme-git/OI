import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:oi/utils/constatnt.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../providers/auth/user_provider.dart';
import '../../../providers/map/location_provider.dart';

class VehicleMap extends StatefulWidget {
  const VehicleMap({Key? key}) : super(key: key);

  @override
  State<VehicleMap> createState() => _VehicleMapState();
}

class _VehicleMapState extends State<VehicleMap> {
  final Completer<GoogleMapController> _controller = Completer();

  GoogleMapController? controller;

  bool myLocation = false;

  bool _isNight_map = false;

  static const CameraPosition _locationColombo = CameraPosition(
    target: LatLng(6.927079, 79.861244),
    bearing: 92.8334901395799,
    zoom: 16,
  );

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }

  Future<void> _disposeController() async {
    controller = await _controller.future;
    controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    DateFormat dateFormat = new DateFormat.Hm();
    DateTime now = DateTime.now();
    now = DateTime.parse(now.toString());
    final start = DateTime(now.year, now.month, now.day, 19);
    final stop = DateTime(now.year, now.month, now.day, 06);

    if (now.isAfter(start) && now.isBefore(stop)) {
      _isNight_map = false;
    } else if (!now.isAfter(start) && !now.isBefore(stop)) {
      _isNight_map = true;
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: _appBar(),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                "User",
                style: TextStyle(color: Colors.grey[700]),
              ),
              accountEmail: Text(
                "user@gmail.com",
                style: TextStyle(color: Colors.grey[700]),
              ),
            ),
            Center(
              child: Consumer<UserProvider>(
                builder: (context, value, child) {
                  if (value.googlAaccount != null) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                            backgroundImage: Image.network(
                                    value.googlAaccount!.photoUrl ?? '')
                                .image,
                            radius: 50),
                        Text(value.googlAaccount!.displayName ?? ''),
                        Text(value.googlAaccount!.email),
                        ActionChip(
                            avatar: Icon(Icons.logout),
                            label: Text("logout"),
                            onPressed: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.remove('phone_number');
                              Provider.of<UserProvider>(context, listen: false)
                                  .logOut(context);
                            }),
                      ],
                    );
                  } else if (value.userData != null) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(value.userData!["name"] ?? ''),
                        Text(">>> : " + value.userData!["email"]),
                        ActionChip(
                            avatar: Icon(Icons.logout),
                            label: Text("logout"),
                            onPressed: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.remove('phone_number');
                              Provider.of<UserProvider>(context, listen: false)
                                  .logOutFb(context);
                            }),
                      ],
                    );
                  } else {
                    return Consumer<UserProvider>(
                      builder: (context, value, child) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(value.getuserModel!.firstname.toString()),
                              Text(value.getuserModel!.email.toString()),
                              ActionChip(
                                  avatar: Icon(Icons.logout),
                                  label: Text("logout"),
                                  onPressed: () async {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.remove('phone_number');
                                    Provider.of<UserProvider>(context,
                                            listen: false)
                                        .logOut(context);
                                  }),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: size.height / 1.55,
            width: size.width,
            child: Stack(
              children: [
                Container(
                  child: Consumer2<LocationProvider, UserProvider>(
                    builder: (context, values, values2, child) {
                      return GoogleMap(
                        myLocationButtonEnabled: false,
                        compassEnabled: false,
                        mapToolbarEnabled: false,
                        myLocationEnabled: myLocation,
                        mapType: MapType.normal,
                        zoomControlsEnabled: false,
                        zoomGesturesEnabled: true,
                        initialCameraPosition: _locationColombo,
                        onMapCreated: (controller) async {
                          _controller.complete(controller);

                          String value = _isNight_map
                              ? await DefaultAssetBundle.of(context).loadString(
                                  'assets/map_styles/map_style.json')
                              : await DefaultAssetBundle.of(context).loadString(
                                  'assets/map_styles/map_style_night.json');

                          controller.setMapStyle(value);

                          // values.setFocus("pick");
                          _goToTheLake(values.getPick?.position?.latitude,
                              values.getPick?.position?.longitude);
                        },
                        markers: values.markers.values.toSet(),
                        // polylines: values.polylines.values.toSet(),
                        polylines: values.getPolyline,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            child: Row(
              children: [
                CustomCardTile(image: "threewheel2.png"),
                CustomCardTile(image: "car.png"),
                CustomCardTile(image: 'prious.png'),
                CustomCardTile(image: 'hiace.png'),
                CustomCardTile(image: 'wagon1.png'),
              ],
            ),
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  Icon(
                    MaterialCommunityIcons.cash,
                    size: 30,
                    color: Colors.green,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Cash"),
                ],
              ),
              Row(
                children: [
                  Icon(
                    MaterialCommunityIcons.square_edit_outline,
                    size: 30,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Add note"),
                ],
              ),
              Row(
                children: [
                  Icon(
                    MaterialCommunityIcons.cog_outline,
                    size: 30,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("promo"),
                ],
              ),
            ],
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(0.0),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {},
              child: Ink(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.orangeAccent,
                  // gradient: const LinearGradient(
                  //     colors: [Colors.red, Colors.orange]),
                ),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  child: const Text('Book Now', textAlign: TextAlign.center),
                ),
              ),
            ),
          )
        ],
      ),
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

    // controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    Provider.of<LocationProvider>(context, listen: false)
        .setLatitude(position.latitude);

    // Provider.of<LocationProvider>(context, listen: false)
    //     .currentLocationAddPlace(latLngPosition);
    Provider.of<LocationProvider>(context, listen: false)
        .getPolyLine(controller);
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      leading: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          height: 5,
          width: 5,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.white),
          child: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(MaterialCommunityIcons.sort_variant),
                color: Colors.black,
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
        ),
      ),
    );
  }
}

class CustomCardTile extends StatelessWidget {
  const CustomCardTile({
    required this.image,
    Key? key,
  }) : super(key: key);

  final String image;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Container(
        width: 125,
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.black,
            width: 0.5,
          ),
        ),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("IN 21 mins"),
              Image.asset(
                Constants.imageAsset(image),
                scale: 3,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Tuk",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    MaterialCommunityIcons.account_outline,
                    size: 18,
                    color: Colors.grey,
                  ),
                  Text("2")
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: new Divider(
                  color: Colors.grey,
                ),
              ),
              const Text(
                "LKR 176.37",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Row(
                children: const [
                  Icon(
                    MaterialCommunityIcons.star,
                    color: Colors.amber,
                  ),
                  Text(
                    "Earn 1.8 stars",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
