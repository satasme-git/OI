import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';

class SignUpProvider extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;

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

  Future<void> startSignUp(BuildContext context) async {
    try {
      if (inputValidation()) {
        // Logger().i();
      }
    } catch (e) {
      Logger().e(e);
    }
  }
}
