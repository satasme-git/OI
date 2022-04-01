import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:logger/logger.dart';
import 'package:oi/models/objects.dart';
import 'package:oi/providers/auth/user_provider.dart';
import 'package:oi/providers/map/location_provider.dart';
import 'package:oi/screens/adress_screen/place_service.dart';
import 'package:oi/utils/global_data.dart';
import 'package:provider/provider.dart';

import '../../providers/map/vehicle_provider.dart';
import '../../utils/util_funtions.dart';
import '../home_screen/main_map/map_screen2.dart';
import '../home_screen/vehicle_select_map/vehicle_map.dart';

class SearchAddress2 extends StatefulWidget {
  const SearchAddress2({Key? key}) : super(key: key);

  @override
  State<SearchAddress2> createState() => _SearchAddress2State();
}

class _SearchAddress2State extends State<SearchAddress2> {
  final _destinationController = TextEditingController();
  final _originController = TextEditingController();
  @override
  void dispose() {
    _destinationController.dispose();
    _originController.dispose();
    super.dispose();
  }

  PlaceApi _placeApi = PlaceApi.instance;
  bool buscando = false;
  List<Place> _predictions = [];

  _inputOnChanged(String query) {
    if (query.trim().length > 2) {
      setState(() {
        buscando = true;
      });
      _search(query);
    } else {
      if (buscando || _predictions.length > 0) {
        setState(() {
          buscando = false;
          _predictions = [];
        });
      }
    }
  }

  _search(String query) {
    _placeApi
        .serchPredictions(query)
        .asStream()
        .listen((List<Place>? prediction) {
      if (Icons.batch_prediction_sharp != null) {
        setState(() {
          buscando = false;
          _predictions = prediction ?? [];
          print("Resolution: ${prediction?.length}");
        });

        //
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          "Enter the description",
          style: TextStyle(
              fontSize: 15.0, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //       builder: (BuildContext context) => MapSample2()),
            // );
            UtilFuntions.goBack(context);
          },
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
        ),
        bottom: PreferredSize(
          child: Padding(
              padding: const EdgeInsets.only(
                  left: 5.0, right: 5, top: 15.0, bottom: 15),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 10, top: 10),
                    width: 60,
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
                          decoration: BoxDecoration(
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
                          "Drop",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Consumer<LocationProvider>(
                          builder: (context, value, child) {
                            return AddressInput(
                              // text: "Pick",
                              controller: _originController,
                              textColor: Colors.blueAccent,
                              // iconData: Icons.gps_fixed,
                              hintText: value.getPick?.address != null
                                  ? value.getPick?.address
                                  : "Enter Pick location here",
                              val: "pick",
                              onChanged: _inputOnChanged,
                              enabled: true,
                            );
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            AddressInput(
                              controller: _destinationController,
                              // iconData: Icons.place_sharp,
                              textColor: Colors.amber[400]!,
                              // text: "Drop",
                              val: "drop",
                              hintText: "Enter Drop location here",
                              onChanged: this._inputOnChanged,
                              enabled: true,
                            ),
                            const InkWell(
                              child: Icon(
                                Icons.add,
                                color: Colors.black,
                                size: 28,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              )),
          preferredSize: Size.fromHeight(100),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            if (_predictions.length > 0)
              if (buscando)
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _predictions.length,
                      itemBuilder: (_, i) {
                        final Place item = _predictions[i];

                        return ListTile(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.grey, width: 0.05),
                          ),
                          title: Text(item.description),
                          leading: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: Colors.grey[200],
                            ),
                            child: const Icon(
                              Icons.location_on,
                              color: Colors.orange,
                              size: 18,
                            ),
                          ),
                          onTap: () {
                            serchPredictions(item.placeId);

                            // print(responses.toString());
                          },
                        );
                      }),
                )
            else
              SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  // height: size.height / 5,
                  width: size.width,
                  color: Colors.white,
                  child: Consumer2<LocationProvider, UserProvider>(
                    builder: (context, value, value2, child) {
                      return Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(
                                  Icons.place_sharp,
                                  size: 18,
                                ),
                              ),
                              // SizedBox(width: 10,),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PlacePicker(
                                          apiKey: GlobalData
                                              .API_key, // Put YOUR OWN KEY here. Should be the same for android and ios
                                          onPlacePicked: (result) {
                                            if (value.pickLocationfocus ==
                                                "pick") {
                                              value.startAddPlace(result);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        MapSample2()),
                                              );
                                            } else if (value
                                                    .pickLocationfocus ==
                                                "drop") {
                                              value.startAddPlace(result);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        VehicleMap()),
                                              );
                                            }
                                          },
                                          initialPosition: const LatLng(
                                              37.42796133580664,
                                              -122.085749655962),
                                          useCurrentLocation: true,
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "Set location on map",
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.black, width: 0.08)),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  value2.getuserModel!.homeaddress == null
                                      ? Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PlacePicker(
                                              apiKey: GlobalData
                                                  .API_key, // Put YOUR OWN KEY here. Should be the same for android and ios
                                              onPlacePicked: (result) {
                                                value2
                                                    .setUserHomeAddresessPlace(
                                                        result);
                                                UtilFuntions.goBack(context);
                                              },
                                              initialPosition: const LatLng(
                                                  37.42796133580664,
                                                  -122.085749655962),
                                              useCurrentLocation: true,
                                            ),
                                          ),
                                        )
                                      : setSelectedAddress(context,"home");
                                },
                                child: addressTile(
                                  Icons.home_outlined,
                                  "Home",
                                  22,
                                  value2.getuserModel!.homeaddress != null
                                      ? value2.getuserModel!.homeaddress!
                                          .addressString
                                      : "Add home address here",
                                  size,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  value2.deleteHomeAddress();
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 2),
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    color: Colors.grey[100],
                                  ),
                                  child: const Icon(
                                    MaterialCommunityIcons.trash_can_outline,
                                    size: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.black, width: 0.08)),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  value2.getuserModel!.workaddress == null
                                      ? Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PlacePicker(
                                              apiKey: GlobalData
                                                  .API_key, // Put YOUR OWN KEY here. Should be the same for android and ios
                                              onPlacePicked: (result) {
                                                value2
                                                    .setUserWorkAddresessPlace(
                                                        result);
                                                UtilFuntions.goBack(context);
                                              },
                                              initialPosition: const LatLng(
                                                  37.42796133580664,
                                                  -122.085749655962),
                                              useCurrentLocation: true,
                                            ),
                                          ),
                                        )
                                      : setSelectedAddress(context,"work");
                                },
                                child: addressTile(
                                  Icons.work_outline,
                                  "Work",
                                  18,
                                  value2.getuserModel!.workaddress != null
                                      ? value2.getuserModel!.workaddress!
                                          .addressString
                                      : "Add work address here",
                                  size,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  value2.deleteWorkAddress();
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 2),
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    color: Colors.grey[100],
                                  ),
                                  child: const Icon(
                                    MaterialCommunityIcons.trash_can_outline,
                                    size: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  Row addressTile(
    IconData icon,
    String title,
    double iconSize,
    String? lbltext,
    Size size,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {},
          child: Container(
            height: 35,
            width: 35,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 244, 213),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              size: iconSize,
              color: Colors.amber[800],
            ),
          ),
        ),

        // SizedBox(width: 10,),
        Container(
          width: size.width - 105,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  lbltext.toString(),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

//autocomplete location serach and set on the map if it is pick on the main map and if it is drop on the vehicle map

  Future<void> serchPredictions(String result) async {
    final geocoding = GoogleMapsGeocoding(apiKey: GlobalData.API_key);
    final response = await geocoding.searchByPlaceId(result);

    Provider.of<LocationProvider>(context, listen: false)
        .setAddressGeo(response);

    String location_focus =
        Provider.of<LocationProvider>(context, listen: false).pickLocationfocus;

    if (location_focus == "pick") {
      Provider.of<LocationProvider>(context, listen: false)
          .setAddressGeo(response);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (BuildContext context) => MapSample2()),
      );
    } else if (location_focus == "drop") {
      Provider.of<LocationProvider>(context, listen: false)
          .setAddressGeo(response);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (BuildContext context) => VehicleMap()),
      );
    }
    //fetch vehicles
    Provider.of<VehicleProvider>(context,listen:false).fetchVehicles();
  }
}

class AddressInput extends StatelessWidget {
  // final IconData iconData;
  TextEditingController? controller;
  final String? hintText;
  Function? onTap;
  final bool enabled;
  final void Function(String)? onChanged;
  // final String text;
  final String val;
  final Color textColor;

  AddressInput({
    Key? key,
    // required this.iconData,
    this.controller,
    required this.hintText,
    this.onTap,
    required this.enabled,
    this.onChanged,
    required this.val,
    // required this.text,
    required this.textColor,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Icon(
        //   this.iconData,
        //   size: 18,
        //   color: Colors.black,
        // ),
        // Text(
        //   text,
        //   style: TextStyle(
        //     fontSize: 15,
        //     fontWeight: FontWeight.bold,
        //     color: textColor,
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Container(
              height: 40.0,
              width: MediaQuery.of(context).size.width / 1.48,
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.grey[100],
              ),
              child: Consumer<LocationProvider>(
                builder: (context, value, child) {
                  return TextField(
                    controller: controller,
                    onChanged: onChanged,
                    onTap: () => value.setFocus(val),
                    enabled: enabled,
                    decoration: InputDecoration.collapsed(hintText: hintText),
                  );
                },
              )),
        )
      ],
    );
  }
}

setSelectedAddress(BuildContext context,String res) {
  String value =
      Provider.of<LocationProvider>(context, listen: false).pickLocationfocus;
  if (value == "pick") {
    Provider.of<LocationProvider>(context, listen: false)
        .startAddSelectedPlace(context,res);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) => MapSample2()),
    );
  } else if (value == "drop") {
    Provider.of<LocationProvider>(context, listen: false)
        .startAddSelectedPlace(context,res);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) => VehicleMap()),
    );
  }

   //fetch vehicles
    Provider.of<VehicleProvider>(context,listen:false).fetchVehicles();


}
