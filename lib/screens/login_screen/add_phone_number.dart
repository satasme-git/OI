import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oi/componants/custom_text.dart';
import 'package:oi/providers/auth/otp_provider.dart';
import 'package:oi/providers/auth/timer_provider.dart';
import 'package:oi/utils/constatnt.dart';
import 'package:provider/provider.dart';

class AddPhoneNumber extends StatefulWidget {
  const AddPhoneNumber({Key? key}) : super(key: key);

  @override
  _AddPhoneNumberState createState() => _AddPhoneNumberState();
}

class _AddPhoneNumberState extends State<AddPhoneNumber> {
  Future<bool> initBackButton() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: initBackButton,
      child: Scaffold(
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
                                right:
                                    BorderSide(color: Colors.grey, width: 0.5),
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
                                return TextFormField(
                                  controller: value.phoneController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(9),
                                    FilteringTextInputFormatter.allow(
                                        RegExp("[0-9]")),
                                    //To remove first '0'
                                    FilteringTextInputFormatter.deny(
                                        RegExp(r'^0+')),
                                    //To remove first '94' or your country code
                                    FilteringTextInputFormatter.deny(
                                        RegExp(r'^94+')),
                                  ],
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    labelText: 'Mobile Number',

                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Consumer2<OTPProvider, TimerProvider>(
                      builder: (context, value, value2, child) {
                        return Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 5, top: 5),
                              alignment: Alignment.centerLeft,
                              child: value.checkValidation != true
                                  ? Text(
                                      value.errorString,
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 12,
                                      ),
                                    )
                                  : null,
                            ),
                            const SizedBox(
                              height: 30,
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
                                value.startRegister(context);
                   
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
                                  child: const Text('Next',
                                      textAlign: TextAlign.center),
                                ),
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
