import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:oi/models/user_model.dart';
import 'package:uuid/uuid.dart';

class AuthController {
  final uuid = Uuid();

  FirebaseAuth auth = FirebaseAuth.instance;

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<UserModel?> registerUser(
      BuildContext context, String phone, String otp) async {
    UserModel? userModel;
    final docId = uuid.v5(Uuid.NAMESPACE_URL, phone);
    // get the unique document id auto generated
    // String docId = users.doc().id;
    await users.doc(docId).set({
      'uid': docId,
      'email': '',
      'name': '',
      'otp': otp,
      'phone': phone,
  
    }).then((value) async {
      DocumentSnapshot snapshot = await users.doc(docId).get();
      // result = 1;
      Logger().d(snapshot.data());
      userModel = UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
    });
    return userModel;
  }

  // Future<UserModel?> getUserData(String id) async {
  //   try {
  //     DocumentSnapshot snapshot = await users.doc(id).get();
  //     Logger().i(snapshot.data());
  //     UserModel userModel =
  //         UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
  //     Logger().d(userModel.name);

  //     return userModel;
  //   } catch (e) {
  //     Logger().e(e);
  //   }
  // }

  Future<UserModel?> updateUser(BuildContext context, String docId, String fname,
      String lname, String email) async {
        UserModel? userModel;
    Logger().d(docId);
    await users.doc(docId).update({
      'email': email,
      'firstname': fname,
      'lastname': lname,
      'status':1,
    }).then((value) async {
      DocumentSnapshot snapshot = await users.doc(docId).get();
      // result = 1;
      Logger().d(snapshot.data());
      userModel = UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
    });
    return userModel;
  }
  
}
