import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:oi/componants/custom_text.dart';
import 'package:oi/providers/auth/otp_provider.dart';

import 'package:oi/screens/login_screen/otp_screen.dart';
import 'package:oi/utils/constatnt.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';



class Example2 extends StatefulWidget {
  const Example2({Key? key}) : super(key: key);

  @override
  _Example2State createState() => _Example2State();
}

class _Example2State extends State<Example2> {

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 80),
                    child: CustomText(text: "Enter your mobile number"),
                  ),
                  const SizedBox(
                    height: 41,
                  ),
                  Image.asset(
                    Constants.imageAsset('phone_number.png'),
                  ),
                  const SizedBox(
                    height: 21,
                  ),
                  const CustomText(
                    text: "Slect your preffered language",
                    color: Colors.grey,
                    fontsize: 13,
                  ),
                  const CustomText(
                    text: "to continue",
                    color: Colors.grey,
                    fontsize: 13,
                  ),
                  const SizedBox(
                    height: 63,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: size.width / 4.0,
                          decoration: const BoxDecoration(
                            border: Border(
                              right: BorderSide(color: Colors.grey, width: 0.5),
                            ),
                          ),
                          child: CountryCodePicker(
                            onChanged: print,
                            // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                            initialSelection: '+94',
                            favorite: ['+94', 'SL'],
                            // optional. Shows only country name and flag
                            showCountryOnly: false,
                            // optional. Shows only country name and flag when popup is closed.
                            showOnlyCountryWhenClosed: false,
                            // optional. aligns the flag and the Text left
                            alignLeft: false,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: size.width / 1.8,
                          // height: 55,
                          child: Consumer<OTPProvider>(
                            builder: (context, value, child) {
                              return TextField(
                                controller: value.phoneController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Mobile Number',
                                  // errorText: "Phone number required",
                                  // hintText: 'Enter a search term',
                                  // labelStyle: TextStyle(fontSize: 12)
                                ),
                                
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Consumer<OTPProvider>(
                    builder: (context, value, child) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(0.0),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          value.test2();
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
                            child:
                                const Text('Next', textAlign: TextAlign.center),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
