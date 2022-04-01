import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  void initState() {
    // TODO: implement initState
    setState(() {
      myLocation = false;
    });
    super.initState();
  }

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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
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
                  tooltip:
                      MaterialLocalizations.of(context).openAppDrawerTooltip,
                );
              },
            ),
          ),
        ),
      ),
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
      body: Stack(
        children: [
          Container(
            height: size.height,
            width: size.width,
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
                        ? await DefaultAssetBundle.of(context)
                            .loadString('assets/map_styles/map_style.json')
                        : await DefaultAssetBundle.of(context).loadString(
                            'assets/map_styles/map_style_night.json');

                    controller.setMapStyle(value);

                  },
                  markers: values.markers.values.toSet(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
