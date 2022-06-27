import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:oi/providers/map/location_provider.dart';
import 'package:oi/providers/map/vehicle_provider.dart';
import 'package:oi/utils/constatnt.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../controller/location_controller.dart';
import '../../../providers/auth/user_provider.dart';
import '../../../utils/app_colors.dart';
import '../../add_vehicle/add_vehicle.dart';
import '../../adress_screen/search_address2.dart';
import '../../driver_screen/add_driver.dart';
import 'widgets/custom_listtile.dart';

class MapSample2 extends StatefulWidget {
  @override
  State<MapSample2> createState() => MapSample2State();
}

class MapSample2State extends State<MapSample2> {
  final Completer<GoogleMapController> _controller = Completer();
  final LocationController _locationController = LocationController();
  GoogleMapController? controller;
  bool isSignupScreen = false;
  bool myLocation = false;
  double currentLatitude = 0.0;
  BitmapDescriptor? sourceIcon;

  bool _isNight_map = false;

  static const CameraPosition _locationColombo = CameraPosition(
    target: LatLng(6.927079, 79.861244),
    bearing: 92.8334901395799,
    zoom: 16,
  );

  void isSignUp(bool val) {
    setState(() {
      isSignupScreen = val;
    });
  }

  @override
  void initState() {
    setState(() {
      myLocation = true;
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
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                Color.fromRGBO(247, 148, 29, 1),
                Color.fromRGBO(254, 203, 48, 1),
                // Colors.blue,
                // Colors.purple,
              ],
            ),
          ),
          // color: Color.fromRGBO(50,75,205,1),
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                accountEmail: Text(''),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                accountName: Consumer<UserProvider>(
                  builder: (context, value, child) {
                    return Row(
                      children: <Widget>[
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(shape: BoxShape.circle),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(55),
                            child: Image.asset(
                              Constants.imageAsset(
                                "profile.png",
                              ),

                              // width: 170.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, left: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Chamil pathirana",
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "chamiljay88@gmail.com",
                                style: GoogleFonts.poppins(
                                  fontSize: 8,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
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
                                Provider.of<UserProvider>(context,
                                        listen: false)
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
                                Provider.of<UserProvider>(context,
                                        listen: false)
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
              Consumer<VehicleProvider>(
                builder: (context, value, child) {
                  return Column(
                    children: [
                      CustomListTile(
                        text: "Profile",
                        iconleading: MaterialCommunityIcons.account_outline,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => AddVehcle()),
                          );
                        },
                      ),
                      
                      CustomListTile(
                        text: "My Trips",
                        iconleading: MaterialCommunityIcons.routes,
                        onTap: () {
                           Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => AddDriver()),
                          );
                        },
                      ),
                      CustomListTile(
                        text: "Payment",
                        iconleading: MaterialCommunityIcons.credit_card_outline,
                        onTap: () {},
                      ),

                      CustomListTile(
                        text: "Notification",
                        iconleading: MaterialCommunityIcons.bell_outline,
                        onTap: () {},
                      ),
                      CustomListTile(
                        text: "Helps",
                        iconleading: MaterialCommunityIcons.help_circle_outline,
                        onTap: () {},
                      ),
                      CustomListTile(
                        text: "Free trips",
                        iconleading: MaterialCommunityIcons.gift_outline,
                        onTap: () {},
                      ),
                      CustomListTile(
                        text: "Settings",
                        iconleading: MaterialCommunityIcons.cog_outline,
                        onTap: () {},
                      ),
                      Divider(), //here is a divider

                      CustomListTile(
                        text: "Logout",
                        iconleading: MaterialCommunityIcons.power,
                        onTap: () {},
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
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
                    values.setFocus("pick");

                    _goToTheLake(values.getPick?.position?.latitude,
                        values.getPick?.position?.longitude, values.getPick);
                    // values.getCurentLocationisSet != 0.0
                    //     ? _goToTheLake(
                    //         values2.getlattiude, values2.getlongitude)
                    //     : _locationColombo;
                  },
                  markers: values.markerOrigin.values.toSet(),

                  //  markers: {
                  //            Marker(
                  //             markerId: MarkerId("0"),
                  //             position: LatLng(6.927079, 79.861244),
                  //               icon:originIcon,
                  //             anchor: Offset(0.5, 1.2),

                  //           ),
                  //         }
                );
              },
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 700),
            curve: Curves.easeInOutBack,
            bottom: isSignupScreen ? 250 : 200,
            right: 20,
            child: InkWell(
              onTap: () {},
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 1,
                          spreadRadius: 2),
                    ]),
                child: Icon(Icons.gps_fixed),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 700),
            curve: Curves.easeInOutBack,
            bottom: 20,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 700),
              curve: Curves.easeInOutBack,
              height: isSignupScreen ? 220 : 170,
              // padding: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width - 40,
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        spreadRadius: 3),
                  ]),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            isSignUp(false);
                          },
                          child: Column(
                            children: [
                              Container(
                                width: 176,
                                height: 40,
                                decoration: BoxDecoration(
                                  color:
                                      isSignupScreen ? Colors.white : boxheader,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                        !isSignupScreen
                                            ? MaterialCommunityIcons
                                                .check_circle
                                            : MaterialCommunityIcons
                                                .circle_outline,
                                        size: 20,
                                        color: checkCircle),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    const Text("One way"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            isSignUp(true);
                          },
                          child: Column(
                            children: [
                              Container(
                                width: 176,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: !isSignupScreen
                                      ? Colors.white
                                      : boxheader,
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(15),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                        isSignupScreen
                                            ? MaterialCommunityIcons
                                                .check_circle
                                            : MaterialCommunityIcons
                                                .circle_outline,
                                        size: 20,
                                        color: checkCircle),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    const Text("Return trip"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Column(
                          children: [
                            Container(
                              height: 0.1,
                              width: 176,
                              color: isSignupScreen ? Colors.black : boxheader,
                            ),
                            triangleArrow(
                                !isSignupScreen ? boxheader : Colors.white),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              height: 0.1,
                              width: 176,
                              color: !isSignupScreen ? Colors.black : boxheader,
                            ),
                            triangleArrow(
                                isSignupScreen ? boxheader : Colors.white),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          if (isSignupScreen) returnTrip(),
                          if (!isSignupScreen) oneWay()
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
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

  Container oneWay() {
    return Container(
      margin: EdgeInsets.only(top: 5.0),
      child: Column(
        children: [
          commonTextField("Drop"),

          // buildTextField(MaterialCommunityIcons.mailbox_outline,
          //     "info@dema.com", false, false),
          // buildTextField(
          //     MaterialCommunityIcons.lock_outline, "*********", false, false),
        ],
      ),
    );
  }

  Container returnTrip() {
    return Container(
      margin: EdgeInsets.only(top: 5.0),
      child: Column(
        children: [
          commonTextField("Stop"),
          Container(
            // color: Colors.amber,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 65,
                  // height: 50,
                  // color: Colors.amber,
                  child: Column(
                    children: [
                      Container(
                        height: 15,
                        width: 0.5,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 1,
                      ),
                      Container(
                        height: 6,
                        width: 6,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                        ),
                      ),
                      const Text(
                        "Drop",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    // width: 20,
                    // height: 30,
                    // color: Colors.red,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 8),
                          height: 40,
                          color: Colors.grey[50],
                          child: const TextField(
                            decoration: InputDecoration(
                              hintStyle: TextStyle(fontSize: 17),
                              hintText: ' are stop going',
                              suffixIcon: Align(
                                widthFactor: 1.0,
                                heightFactor: 1.0,
                                child: Icon(MaterialCommunityIcons.plus),
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(5),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row commonTextField(String dropText) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          margin: isSignupScreen
              ? EdgeInsets.only(bottom: 0)
              : EdgeInsets.only(bottom: 10),
          width: 65,
          // height: 50,
          // color: Colors.amber,
          child: Column(
            children: [
              const Text(
                "Pickup",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              Container(
                height: 6,
                width: 6,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              const SizedBox(
                height: 1,
              ),
              Container(
                height: 20,
                width: 0.5,
                decoration: const BoxDecoration(
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 1,
              ),
              Container(
                height: 6,
                width: 6,
                decoration: const BoxDecoration(
                  color: Colors.black,
                ),
              ),
              Text(
                dropText,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber[800],
                ),
              ),
              if (isSignupScreen)
                Column(
                  children: [
                    Container(
                      height: 6,
                      width: 6,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    Container(
                      height: 5,
                      width: 0.5,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        Expanded(
          child: Container(
              // width: 20,
              // height: 30,
              // color: Colors.red,
              child: Consumer2<UserProvider, LocationProvider>(
            builder: (context, value, value2, child) {
              return Column(
                children: [
                  Container(
                    height: 40,
                    color: Colors.grey[50],
                    child: TextField(
                      onTap: () {
                        setState(() {
                          myLocation = false;
                        });

                        value2.setFocus("pick");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    SearchAddress2()));

                        // UtilFuntions.pageTransition(
                        //     context, SearchAddress2(), MapSample());
                      },
                      // enabled: false, //Not clickable and not editable
                      readOnly: true,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(fontSize: 17),
                        hintText: value2.getPick?.address != null
                            ? value2.getPick?.address
                            : 'Your Location',
                        suffixIcon: const Align(
                          widthFactor: 1.0,
                          heightFactor: 1.0,
                          child: Icon(MaterialCommunityIcons.heart_outline),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(5),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: 40,
                    color: Colors.grey[50],
                    child: TextField(
                      onTap: () {
                        setState(() {
                          myLocation = false;
                        });

                        value2.setFocus("drop");
                        // UtilFuntions.pageTransition(
                        //     context, SearchAddress2(), MapSample2());
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    SearchAddress2()));
                      },
                      readOnly: true,
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(fontSize: 17),
                        hintText: 'Where are you going',
                        suffixIcon: Align(
                          widthFactor: 1.0,
                          heightFactor: 1.0,
                          child: Icon(MaterialCommunityIcons.plus),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(5),
                      ),
                    ),
                  )
                ],
              );
            },
          )),
        )
      ],
    );
  }

  Future<void> _goToTheLake(lat, long, getPick) async {
    Logger().e(getPick != null ? getPick?.address.toString() : "asasas");

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
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    Provider.of<LocationProvider>(context, listen: false)
        .setLatitude(position.latitude);

    Provider.of<LocationProvider>(context, listen: false)
        .currentLocationAddPlace(latLngPosition);
  }
}

Transform triangleArrow(Color color) {
  return Transform.rotate(
    angle: 0,
    child: ClipPath(
      clipper: ClipClipper(),
      child: Container(
        width: 20,
        height: 20,
        color: color,
      ),
    ),
  );
}

class ClipClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    Path path = Path();

    path.lineTo(10, 10);
    path.lineTo(
      10,
      10,
    );
    path.lineTo(20, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
