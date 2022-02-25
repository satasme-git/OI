import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oi/screens/adress_screen/select_adresses.dart';
import 'package:oi/utils/app_colors.dart';
import 'package:oi/utils/util_funtions.dart';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  bool isSignupScreen = true;
  void isSignUp(bool val) {
    setState(() {
      isSignupScreen = val;
    });
  }

  final Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          MapWidget(kGooglePlex: _kGooglePlex, controller: _controller),
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
                Container(
                  height: 40,
                  color: Colors.grey[50],
                  child: TextField(
                    onTap: () {
                      UtilFuntions.pageTransition(
                          context, SelectAddress(), MapSample());
                    },
                    // enabled: false, //Not clickable and not editable
                    readOnly: true,
                    decoration: const InputDecoration(
                      hintStyle: TextStyle(fontSize: 17),
                      hintText: 'Your Location',
                      suffixIcon: Align(
                        widthFactor: 1.0,
                        heightFactor: 1.0,
                        child: Icon(MaterialCommunityIcons.heart_outline),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(5),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  height: 40,
                  color: Colors.grey[50],
                  child: const TextField(
                    decoration: InputDecoration(
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
  const MapWidget({
    Key? key,
    required CameraPosition kGooglePlex,
    required Completer<GoogleMapController> controller,
  })  : _kGooglePlex = kGooglePlex,
        _controller = controller,
        super(key: key);

  final CameraPosition _kGooglePlex;
  final Completer<GoogleMapController> _controller;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height,
      child: GoogleMap(
        mapType: MapType.normal,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: {
          const Marker(
            markerId: MarkerId("0"),
            position: LatLng(37.43296265331129, -122.08832357078792),
          )
        },
      ),
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
