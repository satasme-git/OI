// GENERATED CODE - DO NOT MODIFY BY HAND

part of objects;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressModel _$AddressModelFromJson(Map<String, dynamic> json) => AddressModel(
      addressString: json['addressString'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$AddressModelToJson(AddressModel instance) =>
    <String, dynamic>{
      'addressString': instance.addressString,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

VehicleModel _$VehicleModelFromJson(Map<String, dynamic> json) => VehicleModel(
      imgdark: json['imgdark'] as String?,
      imglight: json['imglight'] as String?,
      vehicleId: json['vehicleId'] as String?,
      type: json['type'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      points: (json['points'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$VehicleModelToJson(VehicleModel instance) =>
    <String, dynamic>{
      'imgdark': instance.imgdark,
      'imglight': instance.imglight,
      'vehicleId': instance.vehicleId,
      'type': instance.type,
      'price': instance.price,
      'points': instance.points,
    };

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      uid: json['uid'] as String?,
      firstname: json['firstname'] as String?,
      lastname: json['lastname'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      otp: json['otp'] as String?,
      status: json['status'] as int?,
      homeaddress: json['homeaddress'] == null
          ? null
          : AddressModel.fromJson(json['homeaddress'] as Map<String, dynamic>),
      workaddress: json['workaddress'] == null
          ? null
          : AddressModel.fromJson(json['workaddress'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'uid': instance.uid,
      'firstname': instance.firstname,
      'lastname': instance.lastname,
      'phone': instance.phone,
      'email': instance.email,
      'otp': instance.otp,
      'status': instance.status,
      'homeaddress': instance.homeaddress,
      'workaddress': instance.workaddress,
    };
