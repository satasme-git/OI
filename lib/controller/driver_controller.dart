import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class DriverController{
  FirebaseFirestore firestore=FirebaseFirestore.instance;

  Geoflutterfire geo=Geoflutterfire();

  CollectionReference driver=FirebaseFirestore.instance.collection('drivers');

  Future<void> saveDriverData(String driverName,double lat,double lng)async{
    GeoFirePoint point=geo.point(latitude: lat, longitude: lng);
    String docId=driver.doc().id;
    await driver.doc(docId).set({
      'id':docId,
      'driverName':driverName,
      'position':point.data,
      'type':"3",
    });
  }
}