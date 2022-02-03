import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

import 'package:oi/controller/db_controller.dart';
import 'package:uuid/uuid.dart';

class OTPProvider extends ChangeNotifier {
  var uuid = Uuid();

  var _otpcode = "";
  var userId = "";
  DatabaseController databaseController = new DatabaseController();
  FirebaseAuth _auth = FirebaseAuth.instance;

  final _phoneNumber = TextEditingController();

  TextEditingController get phoneController => _phoneNumber;

  String get getOTPCode => _otpcode;
  // Future<void> test(BuildContext context) async {
  //   try {
  //     var url = Uri.parse(
  //         'https://youandmenest.com/tr_reactnative/checkOTPTokenExpired.php');
  //     var response = await http.get(url);
  //     if (response.statusCode == 200) {
  //       Logger().i(response.body);
  //       if (response.body == "You have logged in") {
  //         try {
  //           // var url2 = Uri.parse(
  //           //     'https://youandmenest.com/tr_reactnative/send_sms_by_otp.php');
  //           // var response = await http.get(url2);
  //           // if (response.statusCode == 200) {}
  //           test2();
  //         } catch (e) {
  //           Logger().e(e);
  //         }
  //       }
  //     } else {
  //       Logger().i("%%%%%%%%%%%%%" + _phoneNumber.text);
  //     }
  //   } catch (e) {
  //     Logger().e(e);
  //   }
  // }

  String get6DigitNumber() {
    Random random = Random();
    String number = '';
    for (int i = 0; i < 4; i++) {
      number = number + random.nextInt(9).toString();
    }
    return number;
  }

  void setOtpCode(code) {
    _otpcode = code;
    notifyListeners();
  }

  bool inputValidation() {
    var isValid = false;
    if (_phoneNumber.text.isEmpty) {
      isValid = false;
    } else {
      isValid = true;
    }
    return isValid;
  }

  Future<void> test2() async {
    try {
      if (inputValidation()) {
        userId = uuid.v5(Uuid.NAMESPACE_URL, _phoneNumber.text);

       
        // UserCredential userCredential =await auth.
        // await FirebaseAuth.instance.c();

        //   try {
        //     UserCredential userCredential =
        //      await  auth.createUserWithEmailAndPassword(email: "chamijay87@gmail.com",password: "amerck2018");
        //  Logger().i(">>>>>>>>>>>>>>>>>>>> "+userCredential.user!.uid);
        //   } on FirebaseAuthException catch (e) {
        //     if (e.code == 'user-not-found') {
        //       Logger().i("No user found for that email.");
        //     } else if (e.code == 'wrong-password') {
        //       Logger().i("Wrong password provided for that user.");
        //     }
        //   }

        // await FirebaseAuth.instance.verifyPhoneNumber(
        //   phoneNumber: '+94 716460440',
        //   verificationCompleted: (PhoneAuthCredential credential) {},
        //   verificationFailed: (FirebaseAuthException e) {
        //      Logger().i(">>>>>>>>>>>>>>>>>>>>>>>>>>");
        //     if (e.code == 'invalid-phone-number') {
        //       Logger().i("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&.");
        //     }

        //     // Handle other errors
        //   },
        //   codeSent: (String verificationId, int? resendToken) {},
        //   codeAutoRetrievalTimeout: (String verificationId) {},
        // );

        // fetchSingleUser(uid);

// var v4 = uuid.v4();

//////////////////////////////////////////////////

        // // Logger().i(">>>>>>>>> ccc :" + otp);
         final otp = get6DigitNumber();
        final response = await http.post(
          Uri.parse(
              'https://youandmenest.com/tr_reactnative/send_sms_by_otp.php'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'phone_number': _phoneNumber.text,
            'otp_code': otp,
          }),
        );

        if (response.statusCode == 200) {
          Logger().i(">>>>>>>>> 1 :" + response.body);
          await DatabaseController().saveUserData(
            "",
            "",
            _phoneNumber.text,
            otp,
            userId,
          );
        } else {
          creaeToken();
          Logger().i(">>>>>>>>> expire :" + response.toString());
        }
      } else {
        Logger().i(">>>>>>>>> incorrect :");
      }
    } catch (e) {
      Logger().e(e);
    }
  }

  Future<void> fetchSingleUser(context, otpval) async {
    databaseController.getUserData(context, userId, otpval);
  }

  Future<void> creaeToken() async {
    try {
      var url = Uri.parse('https://youandmenest.com/tr_reactnative/otp.php');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        Logger().i(response.body);
        if (response.body == "success") {
          Logger().i(">>>>>>>>> 4^^^^^^^^^^^^^^^^^^^^^^^^^^^^:" );
          try {
            final response = await http.post(
              Uri.parse(
                  'https://youandmenest.com/tr_reactnative/send_sms_by_otp.php'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(
                  <String, String>{'phone_number': _phoneNumber.text}),
            );
            if (response.statusCode == 200) {
              Logger().i(">>>>>>>>> 4 :" + response.body);
            }
          } catch (e) {
            Logger().e(e);
          }
        }
      } else {
        Logger().i("%%%%%%%%%%%%%");
      }
    } catch (e) {
      Logger().e(e);
    }
  }
}
