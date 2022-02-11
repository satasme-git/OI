import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:oi/controller/auth_controller.dart';
import 'package:oi/controller/db_controller.dart';
import 'package:oi/models/user_model.dart';
import 'package:oi/screens/login_screen/example2.dart';
import 'package:oi/screens/login_screen/otp_screen.dart';
import 'package:oi/screens/login_screen/sign_up.dart';
import 'package:oi/screens/login_screen/successfull_login.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

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

  final DatabaseController _databaseController = DatabaseController();

  late UserModel _userModel;

  UserModel? get userModel => _userModel;

  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _emailAddress = TextEditingController();
  TextEditingController get firstNameController => _firstName;
  TextEditingController get lastNameController => _lastName;
  TextEditingController get emailController => _emailAddress;

  void setUserModel(UserModel usermodel) {
    _userModel = usermodel;
    notifyListeners();
  }

  fetchSingleUser(context, otpval) {
    Logger().d(otpval + " / " + userModel!.otp);
  }

  void compareOtp(BuildContext context, String otp) {
   
    if (otp == userModel!.otp) {
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
    } 
    // else if (otp != "") {
    //   AwesomeDialog(
    //     context: context,
    //     dialogType: DialogType.ERROR,
    //     animType: AnimType.BOTTOMSLIDE,
    //     title: 'Dialog Title',
    //     desc: 'Incorrect otp',
    //     btnCancelOnPress: () {},
    //     btnOkOnPress: () {},
    //   ).show();
    // }
     else {
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
    Navigator.push(
      context,
      PageTransition(
          child: const SuccessLogin(),
          childCurrent: const SignUp(),
          type: PageTransitionType.rightToLeftJoined,
          duration: const Duration(milliseconds: 300),
          reverseDuration: const Duration(milliseconds: 300),
          curve: Curves.easeInCubic,
          alignment: Alignment.topCenter),
    );

    UserModel userModel;
    userModel = (await AuthController().updateUser(
      context,
      uid,
      _firstName.text,
      _lastName.text,
      _emailAddress.text,
    ))!;

    Logger().d(userModel.email);

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
      Navigator.push(
        context,
        PageTransition(
            child: const Example2(),
            childCurrent: const SuccessLogin(),
            type: PageTransitionType.rightToLeftJoined,
            duration: const Duration(milliseconds: 300),
            reverseDuration: const Duration(milliseconds: 300),
            curve: Curves.easeInCubic,
            alignment: Alignment.topCenter),
      );

      // notifyListeners();
    } catch (e) {
      Logger().e(e);
    }
  }

  Future<void> successLogin(
      BuildContext context, String uid, String value) async {
    try {
      Navigator.push(
        context,
        PageTransition(
            child: const SuccessLogin(),
            childCurrent: const SignUp(),
            type: PageTransitionType.rightToLeftJoined,
            duration: const Duration(milliseconds: 300),
            reverseDuration: const Duration(milliseconds: 300),
            curve: Curves.easeInCubic,
            alignment: Alignment.topCenter),
      );
      UserModel userModel = (await AuthController().updateUser(
        context,
        uid,
        value != "fb" ? googlAaccount!.displayName ?? '' : userData!["name"],
        "",
        value != "fb" ? googlAaccount!.email : userData!["email"],
      ))!;

      // Provider.of<UserProvider>(context,listen: false).setUserData(googlAaccount!,context) ;

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
}
