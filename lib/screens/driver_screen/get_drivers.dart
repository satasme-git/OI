

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:logger/logger.dart';
import 'package:oi/models/driver_model.dart';
import 'package:rxdart/rxdart.dart';

class GetDrivers extends StatefulWidget {
  const GetDrivers({Key? key}) : super(key: key);

  @override
  State<GetDrivers> createState() => _GetDriversState();
}

class _GetDriversState extends State<GetDrivers> {
  Stream<List<DocumentSnapshot>>? stream;
  final _firestore = FirebaseFirestore.instance;

  List<DriverModel> _driverList=[];

  // var radious = BehaviorSubject<double>.seeded(20.0);

  final geo = Geoflutterfire();

  double radious = 100;

  @override
  void initState() {
    super.initState();
    final center = geo.point(latitude: 6.9543, longitude: 80.2046);

    var collectionReference = _firestore.collection('drivers');
    stream = geo.collection(collectionRef: collectionReference).within(
        center: center, radius: radious, field: 'position', strictMode: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: StreamBuilder(
        stream: stream,
        builder: (context,AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
          if(snapshot.hasError){
            return Text("Something went wrong");
          }
          if(snapshot.connectionState==ConnectionState.waiting){
            return  Text("ssssssssssssss");
          }
         Logger().w(snapshot.data!.length);
        _driverList.clear();
        for (var i = 0; i < snapshot.data!.length; i++) {
          Map<String,dynamic> data=snapshot.data![i].data() as Map<String,dynamic>;
          var model=DriverModel.fromJson(data);
          _driverList.add(model);
        }
          return ListView.builder(
              itemCount: _driverList.length,
              scrollDirection: Axis.vertical,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Text(_driverList[index].driverName);
              });
        },
      )),
    );
  }
}
