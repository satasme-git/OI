import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseController {
  //firestore instance create
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  //creare a collection reffrenace
  CollectionReference users = FirebaseFirestore.instance.collection('passengers');

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
}
