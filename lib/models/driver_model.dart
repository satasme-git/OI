import 'package:cloud_firestore/cloud_firestore.dart';

class DriverModel {
  late String id;
  late String driverName;
  late GeoPoint position;
  late String type;
  DriverModel({
    required this.id,
    required this.driverName,
    required this.position,
    required this.type,
  });

  DriverModel.fromJson(Map map) {
    id = map['id'];
    driverName = map["driverName"];
    position = map['position']['geopoint'];
     type = map['type'];
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'driverName': driverName,
      'position': position,
      'type': type,
    };
  }
}
