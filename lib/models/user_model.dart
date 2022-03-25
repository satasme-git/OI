// import 'package:cloud_firestore/cloud_firestore.dart';

part of 'objects.dart';

@JsonSerializable()
class UserModel {
  late String? uid;
  late String? firstname;
  late String? lastname;
  late String? phone;
  late String? email;
  late String? otp;
  late int? status;
  late AddressModel? homeaddress;
  late AddressModel? workaddress;
  UserModel({
    this.uid,
    this.firstname,
    this.lastname,
    this.phone,
    this.email,
    this.otp,
    this.status,
    this.homeaddress,
    this.workaddress,
  });
  // UserModel.fromMap(Map map) {
  //   uid = map['uid'];
  //   firstname = map['firstname'];
  //   lastname = map['lastname'];
  //   phone = map['phone'];
  //   email = map['email'];
  //   otp = map['otp'];
  //   status = map['status'];
  //   homeaddress = map['homeaddress'];
  //   // workaddress = map['workaddress'];
  // }
  // // sending data to our server
  // Map<String, dynamic> toMap() {
  //   return {
  //     'uid': uid,
  //     'firstname': firstname,
  //     'lastname': lastname,
  //     'phone': phone,
  //     'email': email,
  //     'otp': otp,
  //     'status': status,
  //     'homeaddress': homeaddress,
  //     // 'workaddress': workaddress,
  //   };
  // }

   factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
