// import 'package:cloud_firestore/cloud_firestore.dart';
part of 'objects.dart';

@JsonSerializable(explicitToJson: true)
class VehicleModel {
  String? imgdark;
  String? imglight;
  String? vehicleId;
  String? type;
  double? price;
  double? points;

  VehicleModel({
    required this.imgdark,
    required this.imglight,
    required this.vehicleId,
    required this.type,
    required this.price,
    required this.points,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) =>
      _$VehicleModelFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleModelToJson(this);
}
