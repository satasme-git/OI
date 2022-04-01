// import 'dart:ffi';

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:oi/controller/vehicle_controller.dart';

import '../../models/objects.dart';

class VehicleProvider extends ChangeNotifier {
  final VehicleController _vehicleController = VehicleController();
  final ImagePicker _picker = ImagePicker();

  final FirebaseAuth auth = FirebaseAuth.instance;

  final _type = TextEditingController();
  final _1kmprice = TextEditingController();
  final _points = TextEditingController();

  TextEditingController get typeController => _type;
  TextEditingController get priceController => _1kmprice;
  TextEditingController get pointController => _points;

  File _image = File("");
  File get getImg => _image;

  File _imageLight = File("");
  File get getImgLight => _imageLight;

  int _isSelected = -1;
  int get isSelected => _isSelected;

  void setIsVisible(int val) {
    _isSelected = val;
    notifyListeners();
  }
  // bool inputValidation() {
  //   var isValidate = false;
  //   if (_firstName.text.isEmpty ||
  //       _secondName.text.isEmpty ||
  //       _secondName.text.isEmpty) {
  //     isValidate = false;
  //   } else {
  //     isValidate = true;
  //   }
  //   return isValidate;
  // }

  Future<void> startAddVehicle(BuildContext context) async {
    await _vehicleController.saveVehicle(
      _type.text,
      double.parse(_1kmprice.text),
      _image,
      _imageLight,
      double.parse(_points.text),
    );

    notifyListeners();
  }

  Future<void> selectImage() async {
    try {
      // Pick an image
      final XFile? pickFile =
          await _picker.pickImage(source: ImageSource.gallery);
      if (pickFile != null) {
        _image = File(pickFile.path);
        notifyListeners();
      } else {
        Logger().e("no image selected");
      }
    } catch (e) {
      Logger().e(e);
    }
  }

  Future<void> selectImageLight() async {
    try {
      // Pick an image
      final XFile? pickFile =
          await _picker.pickImage(source: ImageSource.gallery);
      if (pickFile != null) {
        _imageLight = File(pickFile.path);
        notifyListeners();
      } else {
        Logger().e("no image selected");
      }
    } catch (e) {
      Logger().e(e);
    }
  }

  /*Single vehicle stores
    list to store single vehicle 
  */
  List<VehicleModel> _vehicle = [];
  //getter for single vehicle list
  List<VehicleModel> get getVehicle => _vehicle;
//fetch vehicles
  Future<void> fetchVehicles() async {
    _vehicle.clear();
    try {
      await _vehicleController.getVehiles().then((value) {
        _vehicle = value;
        Logger().w(_vehicle.length);
        notifyListeners();
      });
    } catch (e) {
      Logger().e(e);
    }
  }
}
