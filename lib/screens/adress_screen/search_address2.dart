import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:logger/logger.dart';
import 'package:oi/providers/auth/user_provider.dart';
import 'package:oi/providers/map/location_provider.dart';
import 'package:oi/screens/adress_screen/place_service.dart';
import 'package:oi/screens/home_screen/map_screen.dart';
import 'package:oi/utils/global_data.dart';
import 'package:oi/utils/util_funtions.dart';
import 'package:provider/provider.dart';

import '../home_screen/map_screen2.dart';
import '../home_screen/vehicle_select_map/vehicle_map.dart';

class SearchAddress2 extends StatefulWidget {
  const SearchAddress2({Key? key}) : super(key: key);

  @override
  State<SearchAddress2> createState() => _SearchAddress2State();
}

class _SearchAddress2State extends State<SearchAddress2> {
  final _destinationController = TextEditingController();
  @override
  void dispose() {
    _destinationController.dispose();
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
        title: Text(
          "Enter the description",
          style: TextStyle(
              fontSize: 15.0, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => MapSample2()),
            );
            // UtilFuntions.goBack(context);
          },
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
        ),
        bottom: PreferredSize(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            child: Column(
              children: [
                AddressInput(
                  iconData: Icons.gps_fixed,
                  hintText: "Enter pick location here",
                  enabled: false,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    AddressInput(
                      controller: _destinationController,
                      iconData: Icons.place_sharp,
                      hintText: "Enter drop location here",
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
                      itemCount: _predictions.length,
                      itemBuilder: (_, i) {
                        final Place item = _predictions[i];

                        return ListTile(
                          title: Text(item.description),
                          leading: const Icon(
                            Icons.location_on,
                            color: Colors.orange,
                          ),
                          onTap: () {
                            serchPredictions(item.placeId);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      MapSample2()),
                            );
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
                  child: Column(
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
                          Consumer<LocationProvider>(
                            builder: (context, value, child) {
                              return Padding(
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
                              );
                            },
                          )
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
                      addressTile(Icons.home_outlined, "Home", 22),
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
                      addressTile(Icons.work_outline, "Add Work", 18),
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  Row addressTile(IconData icon, String title, double iconSize) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 35,
          width: 35,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            icon,
            size: iconSize,
            color: Colors.blueAccent,
          ),
        ),
        // SizedBox(width: 10,),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
          ),
        ),
      ],
    );
  }

  Future<void> serchPredictions(String aaa) async {
    final geocoding = GoogleMapsGeocoding(apiKey: GlobalData.API_key);
    final response = await geocoding.searchByPlaceId(aaa);

    Provider.of<UserProvider>(context, listen: false).setAddressGeo(response);
  }
}

class AddressInput extends StatelessWidget {
  final IconData iconData;
  TextEditingController? controller;
  final String hintText;
  Function? onTap;
  final bool enabled;
  final void Function(String)? onChanged;

  AddressInput({
    Key? key,
    required this.iconData,
    this.controller,
    required this.hintText,
    this.onTap,
    required this.enabled,
    this.onChanged,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          this.iconData,
          size: 18,
          color: Colors.black,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Container(
            height: 40.0,
            width: MediaQuery.of(context).size.width / 1.4,
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: Colors.grey[100],
            ),
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              onTap: () => onTap,
              enabled: enabled,
              decoration: InputDecoration.collapsed(hintText: hintText),
            ),
          ),
        )
      ],
    );
  }
}
