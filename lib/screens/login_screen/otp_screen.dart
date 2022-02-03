import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:oi/componants/custom_text.dart';
import 'package:oi/providers/auth/otp_provider.dart';
import 'package:oi/screens/login_screen/sign_up.dart';
import 'package:oi/utils/constatnt.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class OTPScreen extends StatelessWidget {
  const OTPScreen({Key? key}) : super(key: key);

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 80),
                    child: CustomText(text: "Enter the 4-digit code"),
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
                  const CustomText(
                    text: "+940156899 change",
                    color: Colors.grey,
                    fontsize: 12,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Consumer<OTPProvider>(
                    builder: (context, value, child) {
                      return PinCodeTextField(
                        appContext: context,
                        length: 4,
                        obscureText: false,
                        animationType: AnimationType.fade,
                        animationDuration: Duration(milliseconds: 300),
                        pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(10),
                            fieldHeight: 60,
                            fieldWidth: 50,
                            activeFillColor: Colors.grey,
                            borderWidth: 1.0),
                        // errorAnimationController: errorController, // Pass it here
                        onChanged: (values) {
                          // setCode()
                          value.setOtpCode(values);

                          // Logger().i("############################# : "+values);
                          // otpvalue = value;
                          // setState(() {
                          //   currentText = value;
                          // });
                        },
                      );
                    },
                  ),
                  SizedBox(
                    height: 30,
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
                          value.fetchSingleUser(context, value.getOTPCode);
                          // Navigator.push(
                          //   context,
                          //   PageTransition(
                          //       child: const SignUp(),
                          //       childCurrent: const OTPScreen(),
                          //       type: PageTransitionType.rightToLeftJoined,
                          //       duration: const Duration(milliseconds: 300),
                          //       reverseDuration:
                          //           const Duration(milliseconds: 300),
                          //       curve: Curves.easeInCubic,
                          //       alignment: Alignment.topCenter),
                          // );
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
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
