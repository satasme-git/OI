import 'package:dio/dio.dart';

class Place {
  final placeId;
  final description;

  Place({this.placeId, this.description});
  static Place fromJson(Map<String, dynamic> json) {
    return Place(
      placeId: json['place_id'],
      description: json['description'],
    );
  }
}

class PlaceApi {
  PlaceApi._internal();
  static PlaceApi get instance => PlaceApi._internal();

  final Dio _dio = Dio();

  static final String androidKey = "AIzaSyA5aG5dcbUf5M4JIElvBgxb1Of6ScNl7N0";
  static final String ioskey = "AIzaSyA5aG5dcbUf5M4JIElvBgxb1Of6ScNl7N0";
  final apiKey = androidKey;

  Future<List<Place>?> serchPredictions(String input) async {
    try {
      final response = await _dio.get(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json',
        queryParameters: {
          "input": input,
          "key": apiKey,
          "language": "es-ES",
          'mode': 'Mode.overlay',
          "types": [],
          "components": "country:LK"
        },
      );
      // print(response.data);
      final List<Place>? places = (response.data['predictions'] as List)
          .map((item) => Place.fromJson(item))
          .toList();
      return places;
    } catch (e) {
      return null;
    }
    // return places;
  }
}
