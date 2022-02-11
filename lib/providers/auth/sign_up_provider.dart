import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:oi/providers/auth/user_provider.dart';
import 'package:oi/screens/login_screen/example2.dart';
import 'package:oi/screens/login_screen/sign_up.dart';
import 'package:oi/screens/login_screen/successfull_login.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class SignUpProvider extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;

  // var _googleSignIn = GoogleSignIn();
  // GoogleSignInAccount? googlAaccount;

  // GoogleSignInAccount? get getGooglAaccount=>googlAaccount;

  final _firstName = TextEditingController();
  final _secondName = TextEditingController();
  final _emailAddress = TextEditingController();

  TextEditingController get firstNameController => _firstName;
  TextEditingController get secondNameController => _secondName;
  TextEditingController get emailController => _emailAddress;

  bool inputValidation() {
    var isValidate = false;
    if (_firstName.text.isEmpty ||
        _secondName.text.isEmpty ||
        _secondName.text.isEmpty) {
      isValidate = false;
    } else {
      isValidate = true;
    }
    return isValidate;
  }

  // Login(BuildContext context) async {
  //   this.googlAaccount = await _googleSignIn.signIn();
  //   successLogin(context);
  //   notifyListeners();
  // }

  // logOut(BuildContext context) async {
  //   this.googlAaccount = await _googleSignIn.signOut();
  //    successLogout(context);
  //   notifyListeners();
  // }

  Future<void> startSignUp(BuildContext context) async {
    try {
      if (inputValidation()) {
        // Logger().i();
      }
    } catch (e) {
      Logger().e(e);
    }
  }

//  Future<void> successLogout(BuildContext context) async {
//     try {
//       Navigator.push(
//         context,
//         PageTransition(
//             child: const Example2(),
//             childCurrent: const SuccessLogin(),
//             type: PageTransitionType.rightToLeftJoined,
//             duration: const Duration(milliseconds: 300),
//             reverseDuration: const Duration(milliseconds: 300),
//             curve: Curves.easeInCubic,
//             alignment: Alignment.topCenter),
//       );

//       // notifyListeners();
//     } catch (e) {
//       Logger().e(e);
//     }
//   }
//   Future<void> successLogin(BuildContext context) async {
//     try {
//       Provider.of<UserProvider>(context,listen: false).setUserData(googlAaccount!,context) ;
//       Navigator.push(
//         context,
//         PageTransition(
//             child: const SuccessLogin(),
//             childCurrent: const SignUp(),
//             type: PageTransitionType.rightToLeftJoined,
//             duration: const Duration(milliseconds: 300),
//             reverseDuration: const Duration(milliseconds: 300),
//             curve: Curves.easeInCubic,
//             alignment: Alignment.topCenter),
//       );

//       // notifyListeners();
//     } catch (e) {
//       Logger().e(e);
//     }
//   }
}
