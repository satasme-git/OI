import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';

import 'package:oi/componants/custom_text.dart';
import 'package:oi/providers/auth/user_provider.dart';
import 'package:oi/providers/map/driver_provider.dart';
import 'package:oi/providers/map/vehicle_provider.dart';
import 'package:oi/utils/constatnt.dart';
import 'package:oi/utils/util_funtions.dart';
import 'package:provider/provider.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../../utils/global_data.dart';

class AddDriver extends StatefulWidget {
  const AddDriver({Key? key}) : super(key: key);

  @override
  State<AddDriver> createState() => _AddDriverState();
}

class _AddDriverState extends State<AddDriver> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  bool validate() {
    if (formkey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> initBackButton() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: initBackButton,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: 5,
              width: 5,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon:
                        const Icon(MaterialCommunityIcons.arrow_collapse_left),
                    color: Colors.black,
                    onPressed: () {
                      UtilFuntions.goBack(context);
                    },
                    tooltip:
                        MaterialLocalizations.of(context).openAppDrawerTooltip,
                  );
                },
              ),
            ),
          ),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SingleChildScrollView(
            child: SizedBox(
              height: size.height,
              width: size.width,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Consumer<DriverProvider>(
                  builder: (context, value, child) {
                    return Form(
                      autovalidateMode: AutovalidateMode.always,
                      key: formkey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 70),
                            child: CustomText(text: "Create New Account"),
                          ),
                          const SizedBox(
                            height: 21,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PlacePicker(
                                    apiKey: GlobalData
                                        .API_key, // Put YOUR OWN KEY here. Should be the same for android and ios
                                    onPlacePicked: (result) {
                                      value.setCordinates(result);
                                      UtilFuntions.goBack(context);
                                    },
                                    initialPosition: const LatLng(
                                        37.42796133580664, -122.085749655962),
                                    useCurrentLocation: true,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              value.addressString == ''
                                  ? 'Set address'
                                  : value.addressString,
                            ),
                            // child: addressTile(
                            //   Icons.work_outline,
                            //   "Work",
                            //   18,
                            //  "Add work address here",
                            //   size,
                            // ),
                          ),
                          const SizedBox(
                            height: 21,
                          ),

                          TextFormField(
                            controller: value.driverController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Required *";
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                              contentPadding: EdgeInsets.all(15),
                              labelText: "Points",
                              hintText: "Enter Points here",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          // TextFormField(
                          //   controller: value.emailController,
                          //   validator: MultiValidator([
                          //     EmailValidator(errorText: "Not a valid email"),
                          //     RequiredValidator(errorText: "Required *")
                          //   ]),
                          //   decoration: InputDecoration(
                          //     contentPadding: EdgeInsets.all(15),
                          //     labelText: "Email Address",
                          //     hintText: "Enter email  here",
                          //     labelStyle: TextStyle(
                          //       color: Colors.black,
                          //       fontSize: 12,
                          //     ),
                          //     border: OutlineInputBorder(
                          //       borderRadius: BorderRadius.circular(10),
                          //       borderSide: const BorderSide(
                          //         color: Colors.grey,
                          //       ),
                          //     ),
                          //   ),
                          // ),

                          const SizedBox(
                            height: 15,
                          ),

                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(0.0),
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: () {
                              value.startAddDriver(context);
                            },
                            child: Ink(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.black,
                                // gradient: const LinearGradient(
                                //     colors: [Colors.red, Colors.orange]),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(18),
                                child: const Text('Create Account',
                                    textAlign: TextAlign.center),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
