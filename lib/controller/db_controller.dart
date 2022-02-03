import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:oi/screens/login_screen/otp_screen.dart';
import 'package:oi/screens/login_screen/sign_up.dart';
import 'package:oi/utils/util_funtions.dart';
import 'package:page_transition/page_transition.dart';

class DatabaseController {
  //firestore instance create
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  //creare a collection reffrenace
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> saveUserData(
      String name, String email, String phone, String otp, String uid) {
    // Call the user's CollectionReference to add a new user
    return users
        .doc(uid)
        .set({
          'name': name,
          'email': email,
          'phone': phone,
          'otp': otp,
          'uid': uid,
        })
        .then((value) => print("User Added : "))
        .catchError((error) => print("Failed to add user: $error"));
  }

  //get user data
  Future<void> getUserData(BuildContext context, String uid, String otp) async {
    try {
      // DocumentSnapshot snapshot = await users.doc(uid).get();
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: uid)
          .where('otp', isEqualTo: otp)
          .get();

      for (var doc in querySnapshot.docs) {
        // Getting data directly
        String name = doc.get('phone');
      }
      if (querySnapshot.docs.isNotEmpty) {
    
        Navigator.push(
          context,
          PageTransition(
              child: const SignUp(),
              childCurrent: const OTPScreen(),
              type: PageTransitionType.rightToLeftJoined,
              duration: const Duration(milliseconds: 300),
              reverseDuration: const Duration(milliseconds: 300),
              curve: Curves.easeInCubic,
              alignment: Alignment.topCenter),
        );

      } else {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Dialog Title',
          desc: 'Incorrect otp',
          btnCancelOnPress: () {},
          btnOkOnPress: () {},
        ).show();
      }
    } catch (e) {
      Logger().e(e);
    }
  }
}
