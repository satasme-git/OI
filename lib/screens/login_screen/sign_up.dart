import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oi/componants/custom_text.dart';
import 'package:oi/componants/custom_text_field.dart';
import 'package:oi/utils/constatnt.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

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
                    child: CustomText(text: "Create New Account"),
                  ),
                  const SizedBox(
                    height: 41,
                  ),
                  Image.asset(
                    Constants.imageAsset('createAccount.png'),
                  ),
                  const SizedBox(
                    height: 21,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const CustomTextField(
                    hintext: "Enter first name here",
                    labeltext: "First Name",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const CustomTextField(
                    hintext: "Enter second name here",
                    labeltext: "Second Name",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const CustomTextField(
                    hintext: "Enter email  here",
                    labeltext: "Email Address",
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          value: true,
                          onChanged: (bool? value) {},
                        ),
                        RichText(
                          text: const TextSpan(children: [
                            TextSpan(
                              text: "I agree with ",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                            TextSpan(
                              text: "Terms ",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            TextSpan(
                              text: "and ",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            TextSpan(
                              text: "Conditions",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
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
                    onPressed: () {},
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
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: RichText(
                      text: const TextSpan(children: [
                        TextSpan(
                          text: "Already have an account? ",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                        TextSpan(
                          text: "Sign In",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        )
                      ]),
                    ),
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
