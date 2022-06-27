import 'package:flutter/cupertino.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:logger/logger.dart';
import 'package:oi/controller/driver_controller.dart';

class DriverProvider extends ChangeNotifier {
  final DriverController _driverController = DriverController();

  double lat = 0;
  double lng = 0;

  String addressString = '';
  String get getAddress => addressString;

  void setCordinates(PickResult result) {
    addressString = result.formattedAddress!;
    lat = result.geometry!.location.lat;
    lng = result.geometry!.location.lng;
    notifyListeners();
  }

  final _driverName = TextEditingController();
  TextEditingController get driverController => _driverName;

  Future<void> startAddDriver(BuildContext context) async {
    try {
      await _driverController.saveDriverData(_driverName.text, lat, lng);
    } catch (e) {
      Logger().e(e);
    }
  }
}
