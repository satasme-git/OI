import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';
import '../models/objects.dart';
import 'package:path/path.dart';

class VehicleController {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  CollectionReference vehicles =
      FirebaseFirestore.instance.collection('vehicles');

  CollectionReference vehicle =
      FirebaseFirestore.instance.collection('vehicles');

  Future<void> saveVehicle(
      String type, double price, File img, File imglight, double points) async {
    UploadTask? task = uploadFile(img);
    final snapshot = await task!.whenComplete(() {});
    final downloadUrl = await snapshot.ref.getDownloadURL();

    UploadTask? tasklight = uploadFile(imglight);
    final snapshotlight = await tasklight!.whenComplete(() {});
    final downloadUrlLight = await snapshotlight.ref.getDownloadURL();

    String docId = vehicle.doc().id;
    VehicleModel vehicleModel;

    await vehicle.doc(docId).set({
      'vehicleId=': docId,
      'type': type,
      'price': price,
      'imgdark': downloadUrl,
      'imglight': downloadUrlLight,
      'points': points
    });
  }

  UploadTask? uploadFile(File file) {
    try {
      final fileName = basename(file.path);
      final destination = 'vehicleImage/$fileName';
      final vehicle = FirebaseStorage.instance.ref(destination);

      Logger().i("******************** : " + destination);

      return vehicle.putFile(file);
    } catch (e) {
      Logger().i(e);
      return null;
    }
  }

  //fetch all vehicles
  Future<List<VehicleModel>> getVehiles() async {
    List<VehicleModel> list = [];

    try {
      QuerySnapshot snapshot =
          await vehicles.orderBy('price', descending: false).get();
      // DocumentSnapshot snapshot = await vehicles.get();

      Logger().e(snapshot.docs.length);
      //quring all the docs in this snapshot
      for (var item in snapshot.docs) {
        //maping to a single model

        VehicleModel model =
            VehicleModel.fromJson(item.data() as Map<String, dynamic>);

        //adding to the model
        list.add(model);
      }
      //return the list
      return list;
    } catch (e) {
      Logger().e(e);
      return list;
    }
  }
}
