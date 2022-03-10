import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:oi/controller/auth_controller.dart';
import 'package:oi/models/objects.dart';
import 'package:oi/models/user_model.dart';
import 'package:oi/screens/login_screen/otp_screen.dart';
import 'package:oi/screens/login_screen/sign_up.dart';
import 'package:oi/utils/util_funtions.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../screens/home_screen/map_screen2.dart';
import '../../screens/login_screen/add_phone_number.dart';

class UserProvider extends ChangeNotifier {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  bool validate() {
    if (formkey.currentState!.validate()) {
      // notifyListeners();
      return true;
    } else {
      // notifyListeners();
      return false;
    }
  }

  Map? userData;

  var _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? googlAaccount;

  // final DatabaseController _databaseController = DatabaseController();
  final AuthController _authController = AuthController();

  UserModel _userModel = UserModel();

  UserModel? get userModel => _userModel;

  //address model
  AddressModel _addressModel =
      AddressModel(addressString: "", latitude: 0, longitude: 0);
  //get address string;
  String get address => _addressModel.addressString != ""
      ? _addressModel.addressString
      : "Your Locations";

  double get getlattiude => _addressModel.latitude;
  double get getlongitude => _addressModel.longitude;

  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _emailAddress = TextEditingController();
  TextEditingController get firstNameController => _firstName;
  TextEditingController get lastNameController => _lastName;
  TextEditingController get emailController => _emailAddress;

  //initialize and check whther the user signed in or not
  void initializeUser(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var phone_number = prefs.getString('phone_number');

    if (phone_number != null) {
      await fetchSingleUser(context, phone_number);
      UtilFuntions.navigateTo(context, MapSample2());

    } else {
      UtilFuntions.navigateTo(context, AddPhoneNumber());
    }
  }

  void setUserModel(UserModel usermodel) {
    _userModel = usermodel;
    notifyListeners();
  }

  fetchSingleUser(context, phone) async {
    _userModel = (await _authController.getUserData(phone))!;

    notifyListeners();
  }

  void compareOtp(BuildContext context, String otp) {
    if (otp == userModel!.otp) {
      UtilFuntions.pageTransition(context, const SignUp(), const OTPScreen());
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
  }

  Future<void> startRegister(BuildContext context, String uid) async {
    _userModel;
    _userModel = (await AuthController().updateUser(
      context,
      uid,
      _firstName.text,
      _lastName.text,
      _emailAddress.text,
    ))!;
    UtilFuntions.pageTransition(context, MapSample2(), const SignUp());

    Logger().d(_userModel.email);

    notifyListeners();
  }

  Login(BuildContext context, String uid) async {
    const value = "google";
    this.googlAaccount = await _googleSignIn.signIn();
    successLogin(context, uid, value);
    notifyListeners();
  }

  logOut(BuildContext context) async {
    this.googlAaccount = await _googleSignIn.signOut();
    successLogout(context);
    notifyListeners();
  }

  Future<void> successLogout(BuildContext context) async {
    try {
      //  UtilFuntions.pageTransition(
      //         context, const AddPhoneNumber(),  MapSample());

      Navigator.push(
        context,
        MaterialPageRoute(builder: (BuildContext context) => AddPhoneNumber()),
      );

      // notifyListeners();

    } catch (e) {
      Logger().e(e);
    }
  }

  Future<void> successLogin(
      BuildContext context, String uid, String value) async {
    try {
      UtilFuntions.pageTransition(context, MapSample2(), const SignUp());

      UserModel userModel = (await AuthController().updateUser(
        context,
        uid,
        value != "fb" ? googlAaccount!.displayName ?? '' : userData!["name"],
        "",
        value != "fb" ? googlAaccount!.email : userData!["email"],
      ))!;

      notifyListeners();
    } catch (e) {
      Logger().e(e);
    }
  }

  loginFb(BuildContext context, String uid) async {
    const value = "fb";
    var result = await FacebookAuth.i.login(
      permissions: ["public_profile", "email"],
    );
    if (result.status == LoginStatus.success) {
      final requestData = await FacebookAuth.i.getUserData(
        fields: "email,name,picture",
      );
      userData = requestData;
      successLogin(context, uid, value);
      notifyListeners();
    }
  }

  logOutFb(BuildContext context) async {
    await FacebookAuth.i.logOut();
    userData = null;
    successLogout(context);
    notifyListeners();
  }

  

  //set user location geocoding result
  void setAddressGeo(GeocodingResponse response) {

    _addressModel.addressString = response.results[0].formattedAddress!;
    _addressModel.latitude = response.results[0].geometry.location.lat;
    _addressModel.longitude = response.results[0].geometry.location.lng;



    notifyListeners();
  }
}
