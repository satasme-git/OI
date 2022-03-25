import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:oi/controller/auth_controller.dart';
import 'dart:math';
import 'package:oi/controller/db_controller.dart';

import 'package:oi/providers/auth/timer_provider.dart';
import 'package:oi/providers/auth/user_provider.dart';
import 'package:oi/screens/adress_screen/search_address2.dart';
import 'package:oi/screens/login_screen/add_phone_number.dart';
import 'package:oi/screens/login_screen/sign_up.dart';
import 'package:oi/screens/login_screen/successfull_login.dart';
import 'package:oi/utils/util_funtions.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../models/objects.dart';
import '../../screens/home_screen/map_screen.dart';
import '../../screens/home_screen/map_screen2.dart';
import '../../screens/login_screen/otp_screen.dart';

class OTPProvider extends ChangeNotifier {
  var uuid = Uuid();
  var _otpcode = "";
  var _validation = true;
  var _otpvalidation = true;

  var _errorString = "";
  var _otperrorString = "";
  var _tryagainbtn = false;
  var _codeallready = false;

  var _otpfildvalidation = false;
  bool get tryAgainBtn => _tryagainbtn;

  DatabaseController databaseController = new DatabaseController();
  FirebaseAuth _auth = FirebaseAuth.instance;

  final _phoneNumber = TextEditingController();
  final _otpCode = TextEditingController();

  TextEditingController get phoneController => _phoneNumber;
  TextEditingController get otpCodeController => _otpCode;

  String get getOTPCode => _otpcode;
  String get errorString => _errorString;
  String get otperrorString => _otperrorString;

  bool get checkValidation => _validation;
  bool get otpcheckValidation => _otpvalidation;

  bool get otpFieldValidation => _otpfildvalidation;

  void changeTryAgainBtn() {
    _tryagainbtn = true;
    notifyListeners();
  }

  void changeTryAgainBtnfalse() {
    _tryagainbtn = false;
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

  bool inputOtpValidation() {
    var isValid = false;
    if ((_otpCode.text.isEmpty)) {
      isValid = false;
      _otperrorString = "Please enter OTP number";
    } else if (_otpCode.text.length == 4) {
      isValid = true;
    }

    return isValid;
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

      final result = (await AuthController().loginCheck(
        _phoneNumber.text,
      ));

      if (!_tryagainbtn) {
        if (inputValidation()) {
          UtilFuntions.pageTransition(
              context, const OTPScreen(), const AddPhoneNumber());

          Provider.of<TimerProvider>(context, listen: false).startTimer();

          sendOtp(otp);
          if (result) {
            userModel = (await AuthController().updateUser1(
              context,
              _phoneNumber.text,
              otp,
            ))!;
            Provider.of<UserProvider>(context, listen: false)
                .setUserModel(userModel);
          } else {
            userModel = (await AuthController().registerUser(
              context,
              _phoneNumber.text,
              otp,
            ))!;

            Provider.of<UserProvider>(context, listen: false)
                .setUserModel(userModel);
          }

          _validation = true;
        } else {
          _validation = false;
        }
      } else {
        sendOtp(otp);
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserModel? userModel;
    if (inputOtpValidation()) {
      bool startEnable =
          Provider.of<TimerProvider>(context, listen: false).startEnable;
      if (!startEnable) {
        userModel = Provider.of<UserProvider>(context, listen: false).getuserModel;

        if (_otpCode.text == userModel!.otp) {
          prefs.setString('phone_number', _phoneNumber.text);

          if (userModel.status == 0) {
            UtilFuntions.pageTransition(
                context, const SignUp(), const OTPScreen());
          } else {
            UtilFuntions.pageTransition(
                context,  MapSample2(), const OTPScreen());
          }

          Provider.of<TimerProvider>(context, listen: false).stopTimer();
          _otpvalidation = true;
        } else {
          _otperrorString = "OTP is Incorrect. Please insert correct OTP";
          _otpvalidation = false;
        }
      } else {
        // _otperrorString = "OTP is expire. please try again";
        _otpvalidation = false;
      }
    } else {
      _otpvalidation = false;
    }
    notifyListeners();
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
    }
  }
}
