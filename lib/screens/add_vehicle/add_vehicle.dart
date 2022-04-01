import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import 'package:oi/componants/custom_text.dart';
import 'package:oi/providers/auth/user_provider.dart';
import 'package:oi/providers/map/vehicle_provider.dart';
import 'package:oi/utils/constatnt.dart';
import 'package:oi/utils/util_funtions.dart';
import 'package:provider/provider.dart';
import 'package:form_field_validator/form_field_validator.dart';

class AddVehcle extends StatefulWidget {
  const AddVehcle({Key? key}) : super(key: key);

  @override
  State<AddVehcle> createState() => _AddVehcleState();
}

class _AddVehcleState extends State<AddVehcle> {
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
                child: Consumer<VehicleProvider>(
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

                          const SizedBox(
                            height: 21,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          value.getImg.path != ''
                              ? GestureDetector(
                                  onTap: () {
                                    value.selectImage();
                                  },
                                  child: Image.file(
                                    value.getImg,
                                    width: size.width / 3,
                                    // height: size.height / 5,
                                    fit: BoxFit.fill,
                                  ),
                                )
                              : IconButton(
                                  onPressed: () {
                                    value.selectImage();
                                  },
                                  icon: Icon(Icons.image),
                                ),
                          SizedBox(
                            height: 20,
                          ),
                          value.getImgLight.path != ''
                              ? GestureDetector(
                                  onTap: () {
                                    value.selectImageLight();
                                  },
                                  child: Image.file(
                                    value.getImgLight,
                                    width: size.width / 3,
                                    // height: size.height / ,
                                    fit: BoxFit.fill,
                                  ),
                                )
                              : IconButton(
                                  onPressed: () {
                                    value.selectImageLight();
                                  },
                                  icon: Icon(Icons.image),
                                ),
                          SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            controller: value.typeController,
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
                              labelText: "vehicle type Name",
                              hintText: "Enter vehicle name here",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: value.priceController,
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
                              labelText: "Price",
                              hintText: "Enter Price here",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: value.pointController,
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
                              value.startAddVehicle(context);
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
