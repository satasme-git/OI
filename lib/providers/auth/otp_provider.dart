import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:oi/controller/auth_controller.dart';
import 'dart:math';
import 'package:oi/controller/db_controller.dart';
import 'package:oi/models/user_model.dart';
import 'package:oi/providers/auth/user_provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../screens/login_screen/example2.dart';
import '../../screens/login_screen/otp_screen.dart';

class OTPProvider extends ChangeNotifier {
  var uuid = Uuid();
  var _otpcode = "";
  var _validation = true;
  var _errorString = "";
  var _tryagainbtn = false;

  var _codeallready = false;

  bool get tryAgainBtn => _tryagainbtn;

  DatabaseController databaseController = new DatabaseController();
  FirebaseAuth _auth = FirebaseAuth.instance;

  final _phoneNumber = TextEditingController();

  TextEditingController get phoneController => _phoneNumber;

  String get getOTPCode => _otpcode;
  String get errorString => _errorString;

  bool get checkValidation => _validation;

  void setOtpCode(code) {
    _otpcode = code;
    notifyListeners();
  }

  void changeTryAgainBtn() {
    _tryagainbtn = true;
    notifyListeners();
  }

  void codeSent() {
    _codeallready = true;
    notifyListeners();
  }

  void get6DigitNumber() {
    Random random = Random();
    String number = "";
    for (int i = 0; i < 4; i++) {
      number = number + random.nextInt(9).toString();
    }
    _otpcode = number;
    notifyListeners();
  }

  bool inputValidation() {
    var isValid = false;
    if (_codeallready) {
      isValid = false;
      _errorString = "Code already sent, Try after 1 minute.";
    } else {
      if ((_phoneNumber.text.isEmpty)) {
        isValid = false;
        _errorString = "Please enter you mobile number";
      } else if (_phoneNumber.text.length < 9) {
        isValid = false;
        _errorString = "Please enter a valid mobile number";
      } else {
        isValid = true;
      }
    }

    return isValid;
  }

  Future<void> startRegister(BuildContext context) async {
    UserModel userModel;
    try {
      get6DigitNumber();
      final otp = getOTPCode;
      if (!_tryagainbtn) {
        if (inputValidation()) {
          Navigator.push(
            context,
            PageTransition(
                child: const OTPScreen(),
                childCurrent: const Example2(),
                type: PageTransitionType.rightToLeftJoined,
                duration: const Duration(milliseconds: 300),
                reverseDuration: const Duration(milliseconds: 300),
                curve: Curves.easeInCubic,
                alignment: Alignment.topCenter),
          );
          // sendOtp(otp);

          userModel = (await AuthController().registerUser(
            context,
            _phoneNumber.text,
            otp,
          ))!;

          Provider.of<UserProvider>(context, listen: false)
              .setUserModel(userModel);

          _validation = true;
        } else {
          _validation = false;
        }
      } else {
        // sendOtp(otp);
        userModel = (await AuthController().registerUser(
          context,
          _phoneNumber.text,
          otp,
        ))!;

        Provider.of<UserProvider>(context, listen: false)
            .setUserModel(userModel);
        _tryagainbtn = false;
      }
      notifyListeners();
    } catch (e) {
      Logger().e(e);
    }
  }

  Future<void> fetchSingleUser(context, otpval) async {
    Provider.of<UserProvider>(context, listen: false)
        .compareOtp(context, otpval);
    // databaseController.getUserData(context, otpval);
  }

  void sendOtp(otp) async {
    final response = await http.post(
      Uri.parse('https://youandmenest.com/tr_reactnative/send_sms_by_otp.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'phone_number': _phoneNumber.text,
        'otp_code': otp,
      }),
    );

    if (response.statusCode == 200) {
      final docId = uuid.v5(Uuid.NAMESPACE_URL, _phoneNumber.text);
      Logger().i(">>>>>>>>> 1 :" + response.body);
      // await DatabaseController().saveUserData(
      //   "",
      //   "",
      //   _phoneNumber.text,
      //   otp,
      //   docId,
      // );
    } else {
      Logger().i(">>>>>>>>> expire :" +
          response.body +
          " / " +
          response.statusCode.toString());
    }
  }
}
