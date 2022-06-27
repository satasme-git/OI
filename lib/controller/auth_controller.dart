import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:logger/logger.dart';

import 'package:uuid/uuid.dart';

import '../models/objects.dart';

class AuthController {
  final uuid = Uuid();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('passengers');

  Future<UserModel?> registerUser(
      BuildContext context, String phone, String otp) async {
    UserModel userModel = UserModel();
    final docId = uuid.v5(Uuid.NAMESPACE_URL, phone);

    userModel.uid = docId;
    userModel.email = "";
    userModel.firstname = "";
    userModel.lastname = "";
    userModel.otp = otp;
    userModel.phone = phone;
    userModel.status = 0;

    await firebaseFirestore
        .collection("passengers")
        .doc(docId)
        .set(userModel.toJson())
        .then((value) async {
      DocumentSnapshot snapshot = await users.doc(docId).get();
      // result = 1;
      Logger().d(snapshot.data());
      userModel = UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
    });

    return userModel;
  }

  Future<UserModel?> updateUser1(
      BuildContext context, String phone, String otp) async {
    UserModel userModel = UserModel();
    final docId = uuid.v5(Uuid.NAMESPACE_URL, phone);

    await users.doc(docId).update({
      'otp': otp,
    }).then((value) async {
      DocumentSnapshot snapshot = await users.doc(docId).get();
      // result = 1;
      Logger().d(snapshot.data());
      userModel = UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
    });

    return userModel;
  }

  Future<bool> loginCheck(
    String phone,
  ) async {
    bool isAvailable = false;
    final docId = uuid.v5(Uuid.NAMESPACE_URL, phone);
    final result = await users.doc(docId).get();

    if (result == null || !result.exists) {
      // Document with id == docId doesn't exist.
      isAvailable = false;
    } else {
      isAvailable = true;
    }

    return isAvailable;
  }

  Future<UserModel?> updateUser(BuildContext context, String docId,
      String fname, String lname, String email) async {
    UserModel? userModel;
    Logger().d(docId);
    await users.doc(docId).update({
      'email': email,
      'firstname': fname,
      'lastname': lname,
      'status': 1,
    }).then((value) async {
      DocumentSnapshot snapshot = await users.doc(docId).get();
      // result = 1;
      Logger().d(snapshot.data());
      userModel = UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
    });
    return userModel;
  }

  Future<UserModel?> getUserData(String phone) async {
    try {
      final docId = uuid.v5(Uuid.NAMESPACE_URL, phone);
      DocumentSnapshot snapshot = await users.doc(docId).get();
      Logger().i(snapshot.data());
      UserModel userModel =
          UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
      Logger().d("&ZZ&& : " + userModel.homeaddress.toString());

      return userModel;
    } catch (e) {
      Logger().e(e);
    }
  }

  Future<UserModel> updateHomeAddress(UserModel user) async {
    UserModel userModel = UserModel();
    await users.doc(user.uid).update({
      'uid': user.uid,
      'firstname': user.firstname,
      'lastname': user.lastname,
      'phone': user.phone,
      'email': user.email,
      'otp': user.otp,
      'status': user.status,
      'homeaddress':
          user.homeaddress != null ? user.homeaddress!.toJson() : null,
      // 'workaddress': user.workaddress!=null?user.workaddress!.toJson():null,
    }).then((value) async {
      DocumentSnapshot snapshot = await users.doc(user.uid).get();
      // result = 1;
      Logger().d(snapshot.data());
      userModel = UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
    });
    return userModel;
  }

  Future<UserModel> updateWorkAddress(UserModel user) async {
    UserModel userModel = UserModel();

    await users.doc(user.uid).update({
      'uid': user.uid,
      'firstname': user.firstname,
      'lastname': user.lastname,
      'phone': user.phone,
      'email': user.email,
      'otp': user.otp,
      'status': user.status,
      // 'homeaddress': user.homeaddress!=null?user.homeaddress!.toJson():null,
      'workaddress':
          user.workaddress != null ? user.workaddress!.toJson() : null,
    }).then((value) async {
      DocumentSnapshot snapshot = await users.doc(user.uid).get();
      // result = 1;
      Logger().d(snapshot.data());
      userModel = UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
    });
    return userModel;
  }
}
