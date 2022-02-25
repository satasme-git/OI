import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:oi/models/user_model.dart';
import 'package:oi/providers/auth/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AuthController {
  final uuid = Uuid();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

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
        .collection("users")
        .doc(docId)
        .set(userModel.toMap())
        .then((value) async {
      DocumentSnapshot snapshot = await users.doc(docId).get();
      // result = 1;
      Logger().d(snapshot.data());
      userModel = UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
    });

    return userModel;
  }











  Future<UserModel?> updateUser1( BuildContext context, String phone, String otp) async {
    UserModel userModel = UserModel();
    final docId = uuid.v5(Uuid.NAMESPACE_URL, phone);


 await users.doc(docId).update({
      'otp': otp,
    }).then((value) async {
      DocumentSnapshot snapshot = await users.doc(docId).get();
      // result = 1;
      Logger().d(snapshot.data());
      userModel = UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
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
      userModel = UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
    });
    return userModel;
  }

  Future<UserModel?> getUserData(String phone) async {
    try {
      final docId = uuid.v5(Uuid.NAMESPACE_URL, phone);
      DocumentSnapshot snapshot = await users.doc(docId).get();
      Logger().i(snapshot.data());
      UserModel userModel =
          UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
      Logger().d(userModel.firstname);

      return userModel;
    } catch (e) {
      Logger().e(e);
    }
  }
}
