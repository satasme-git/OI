import 'package:google_maps_flutter/google_maps_flutter.dart';

class Place {
   late String? id, title, address;
   late LatLng? position;
  Place({
     this.id,
     this.title="",
     this.address,
     this.position,
  });
  Place.fromJson(Map map) {
    id = map['id'];
    title = map['title'];
    address = map['address'];
    position = map['position']['geopoint'];
  }
   Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'address': address,
      'position': position,
     
    };
  }
}
