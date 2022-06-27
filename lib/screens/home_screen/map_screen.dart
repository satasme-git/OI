import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:oi/providers/map/location_provider.dart';
import 'package:oi/utils/app_colors.dart';
import 'package:oi/utils/util_funtions.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../../providers/auth/user_provider.dart';
import '../adress_screen/search_address2.dart';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  bool isSignupScreen = false;
  bool _mapLoading = true;
  void isSignUp(bool val) {
    setState(() {
      isSignupScreen = val;
    });
  }

  final Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(6.927079, 79.861244),
    zoom: 16,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  late GoogleMapController newGooleMapController;

  late Position currentPosition;
  var geoLocator = Geolocator();

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    LatLng latLngPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition =
        new CameraPosition(target: latLngPosition, zoom: 14);
    newGooleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }

  Future<void> _disposeController() async {
    final GoogleMapController controller = await _controller.future;
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //  if(clock_val>)
    final size = MediaQuery.of(context).size;

    List<String> myList = ['US', 'SG', 'US'];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        // title: new Text(
        //   "Hello World",
        //   style: TextStyle(color: Colors.amber),
        // ),

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
            child:
                MapWidget(kGooglePlex: _kGooglePlex, controller: _controller),
          ),

          // Positioned(
          //   top: 40,
          //   child: InkWell(
          //     onTap: () {},
          //     child: Container(
          //       height: 40,
          //       width: 40,
          //       decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(10),
          //           color: Colors.white),
          //       child: Icon(
          //         MaterialCommunityIcons.sort_variant,
          //         color: Colors.black,
          //       ),
          //     ),
          //   ),
          // ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 700),
            curve: Curves.easeInOutBack,
            bottom: isSignupScreen ? 250 : 200,
            right: 20,
            child: InkWell(
              onTap: () async {
                newGooleMapController = await _controller.future;
                locatePosition();
              },
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
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToTheLake,
      //   label: Text('To the lake!'),
      //   icon: Icon(Icons.directions_boat),
      // ),
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
              Text(
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
              SizedBox(
                height: 1,
              ),
              Container(
                height: 20,
                width: 0.5,
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 1,
              ),
              Container(
                height: 6,
                width: 6,
                decoration: BoxDecoration(
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
                      decoration: BoxDecoration(
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
            child: Column(
              children: [
                Consumer<UserProvider>(
                  builder: (context, value, child) {
                    return Container(
                      height: 40,
                      color: Colors.grey[50],
                      child: TextField(
                        onTap: () {
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
                          hintText: value.address != ""
                              ? value.address
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
                    );
                  },
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  height: 40,
                  color: Colors.grey[50],
                  child: TextField(
                    onTap: () {
                      UtilFuntions.pageTransition(
                          context, SearchAddress2(), MapSample());
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
            ),
          ),
        )
      ],
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
                        decoration: BoxDecoration(
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 1,
                      ),
                      Container(
                        height: 6,
                        width: 6,
                        decoration: BoxDecoration(
                          color: Colors.black,
                        ),
                      ),
                      Text(
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

  Widget buildTextField(
      IconData icon, String hintText, bool isPassword, bool isEmail) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        obscureText: isPassword,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: iconColor,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: textColor1),
            borderRadius: BorderRadius.all(
              Radius.circular(35.0),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: textColor1),
            borderRadius: BorderRadius.all(
              Radius.circular(35.0),
            ),
          ),
          contentPadding: EdgeInsets.all(10),
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 14, color: textColor1),
        ),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}

class MapWidget extends StatelessWidget {
  bool _mapLoading = true;
  MapWidget({
    Key? key,
    required CameraPosition kGooglePlex,
    required Completer<GoogleMapController> controller,
  })  : _kGooglePlex = kGooglePlex,
        _controller = controller,
        super(key: key);

  final CameraPosition _kGooglePlex;
  final Completer<GoogleMapController> _controller;

  late GoogleMapController newGooleMapController;

  late Position currentPosition;
  var geoLocator = Geolocator();

  void locatePosition(lat, long) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    LatLng latLngPosition = LatLng(lat != 0 ? lat : position.latitude,
        long != 0 ? long : position.longitude);
    CameraPosition cameraPosition =
        new CameraPosition(target: latLngPosition, zoom: 14);
    newGooleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  @override
  Widget build(BuildContext context) {
    bool _isNight_map = false;
    bool isMapVisible = false;

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

    var size = MediaQuery.of(context).size;
    return Consumer2<UserProvider, LocationProvider>(
      builder: (context, values, values2, child) {
        return GoogleMap(
          myLocationButtonEnabled: false,
          compassEnabled: false,
          mapToolbarEnabled: false,
          // liteModeEnabled: true,
          myLocationEnabled: true,
          mapType: MapType.normal,
          zoomControlsEnabled: false,
          zoomGesturesEnabled: true,
          initialCameraPosition: _kGooglePlex,

          onMapCreated: (GoogleMapController controller) async {
            _mapLoading = false;

            _controller.complete(controller);
            newGooleMapController = controller;
            String value = _isNight_map
                ? await DefaultAssetBundle.of(context)
                    .loadString('assets/map_styles/map_style.json')
                : await DefaultAssetBundle.of(context)
                    .loadString('assets/map_styles/map_style_night.json');
            newGooleMapController.setMapStyle(value);
            locatePosition(values.getlattiude, values.getlongitude);
          },
          markers: values2.marker.values.toSet(),
          
        );
     
      },
    );
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
