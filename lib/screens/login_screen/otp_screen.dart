import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:oi/componants/custom_text.dart';
import 'package:oi/providers/auth/otp_provider.dart';

import 'package:oi/providers/auth/timer_provider.dart';

import 'package:oi/utils/constatnt.dart';
import 'package:oi/utils/util_funtions.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import 'add_phone_number.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({Key? key}) : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  var timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timer = Provider.of<TimerProvider>(context, listen: false);
  }

  @override
  void dispose() {
    timer.stopTimer;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var otpvalue = "1";
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
              child: Consumer2<OTPProvider, TimerProvider>(
                builder: (context, value, value2, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 80),
                        child: CustomText(text: "Enter the 4-digit code"),
                      ),
                      const SizedBox(
                        height: 41,
                      ),
                      Lottie.asset(
                        'assets/images/114272-security.json',
                        width: 160,
                        // height: 200,
                        fit: BoxFit.fill,
                      ),
                      // Image.asset(
                      //   Constants.imageAsset('phone_number.png'),
                      // ),
                      const SizedBox(
                        height: 21,
                      ),
                      const CustomText(
                        text: "Didn't Recieve Code?",
                        color: Colors.grey,
                        fontsize: 13,
                      ),
                      const CustomText(
                        text: "Request Again Get Via SMS",
                        color: Colors.black,
                        fontsize: 13,
                      ),
                      const SizedBox(
                        height: 43,
                      ),
                      Center(
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                              text: value.phoneController.text,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  value2.stopTimer();
                                  value.changeTryAgainBtnfalse();
                                  UtilFuntions.pageTransition(
                                      context,
                                      const AddPhoneNumber(),
                                      const OTPScreen());
                                },
                              text: "  Change",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                              ),
                            )
                          ]),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      PinCodeTextField(
                        controller: value.otpCodeController,
                        appContext: context,
                        length: 4,
                        obscureText: false,
                        animationType: AnimationType.fade,
                        animationDuration: const Duration(milliseconds: 300),
                        keyboardType: TextInputType.number,
                        pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(10),
                            fieldHeight: 60,
                            fieldWidth: 50,
                            activeFillColor: Colors.grey,
                            borderWidth: 1.0),
                        onChanged: (values) {
                          // value.setOtpCode(values);
                          // if (values.length == 4) {
                          //   if (timer.stopEnable) {
                          //     value2.stopTimer();

                          value.fetchSingleUser(context, value.getOTPCode);
                          value.changeTryAgainBtnfalse();
                          //   }
                          // }
                        },
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 5, top: 0),
                        alignment: Alignment.centerLeft,
                        child: value.otpcheckValidation != true
                            ? Text(
                                value.otperrorString,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const CustomText(
                        text: "Didn't get the code ?",
                        fontsize: 12,
                      ),
                      RichText(
                        text: TextSpan(children: [
                          const TextSpan(
                            text: "Try again in  ",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                            ),
                          ),
                          (timer.startEnable)
                              ? TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      if (!value2.getisTapped) {
                                        value.changeTryAgainBtn();
                                        value2.setisTapped();
                                        value2.startTimer();
                                        value.startRegister(context);
                                      }
                                    },
                                  text: " Try Again",
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                  ),
                                )
                              : TextSpan(
                                  text: '${timer.minute} : ' +
                                      '${timer.seconds} ',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                        ]),
                      ),
                      const SizedBox(
                        height: 40,
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
                          value2.stopTimer();
                          value.changeTryAgainBtnfalse();
                          value.fetchSingleUser(context, value.getOTPCode);
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
                            child: const Text('Continue',
                                textAlign: TextAlign.center),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
