import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:oi/screens/adress_screen/place_service.dart';

class SearchAddress2 extends StatefulWidget {
  const SearchAddress2({Key? key}) : super(key: key);

  @override
  State<SearchAddress2> createState() => _SearchAddress2State();
}

class _SearchAddress2State extends State<SearchAddress2> {
  final _destinationController = TextEditingController();
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

  //  _search(String query) {
  //   _placeApi
  //       .serchPredictions(query)
  //       .asStream()
  //       .listen((prediction) {
  //     if (prediction != null) {
  //       setState(() {
  //         buscando = false;
  //         // _predictions = prediction ?? [];
  //         print("Resolution: ${prediction.length}");
  //       });

  //       //
  //     }
  //     //  print("Resolution: ${prediction?.length}");
  //   });
  // }
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
      appBar: AppBar(
        title: Text(
          "Enter th description",
          style: TextStyle(
              fontSize: 15.0, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
        ),
        bottom: PreferredSize(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            child: Column(
              children: [
                AddressInput(
                  iconData: Icons.gps_fixed,
                  hintText: "Enter addres here",
                  enabled: false,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    AddressInput(
                      controller: _destinationController,
                      iconData: Icons.place_sharp,
                      hintText: "abc",
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
          preferredSize: Size.fromHeight(70),
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
                          leading: Icon(
                            Icons.location_on,
                            color: Colors.orange,
                          ),
                          onTap: () {
                            print(item.placeId);
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
                            child: Icon(
                              Icons.place_sharp,
                              size: 18,
                            ),
                          ),
                          // SizedBox(width: 10,),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Set location on map",
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Colors.black, width: 0.08)),
                          ),
                        ),
                      ),
                      addressTile(Icons.home_outlined,"Home",22),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Colors.black, width: 0.08)),
                          ),
                        ),
                      ),
                      addressTile(Icons.work_outline,"Add Work",18),
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  Row addressTile(IconData icon,String title,double iconSize) {
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
