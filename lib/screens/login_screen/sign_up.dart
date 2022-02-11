import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:oi/componants/custom_text.dart';
import 'package:oi/componants/custom_text_field.dart';
import 'package:oi/providers/auth/sign_up_provider.dart';
import 'package:oi/providers/auth/user_provider.dart';
import 'package:oi/utils/constatnt.dart';
import 'package:provider/provider.dart';
import 'package:form_field_validator/form_field_validator.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  bool validate() {
    if (formkey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }

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
              child: Consumer<UserProvider>(
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
                        Image.asset(
                          Constants.imageAsset('createAccount.png'),
                        ),
                        const SizedBox(
                          height: 21,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: value.firstNameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Required *";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            labelStyle: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                            contentPadding: EdgeInsets.all(15),
                            labelText: "First Name",
                            hintText: "Enter first name here",
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
                          controller: value.lastNameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Required *";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            labelStyle: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                            contentPadding: EdgeInsets.all(15),
                            labelText: "Second Name",
                            hintText: "Enter second name here",
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
                          controller: value.emailController,
                          validator: MultiValidator([
                            EmailValidator(errorText: "Not a valid email"),
                            RequiredValidator(errorText: "Required *")
                          ]),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(15),
                            labelText: "Email Address",
                            hintText: "Enter email  here",
                            labelStyle: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                          ),
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
                          onPressed: () {
                            if (validate()) {
                              value.startRegister(
                                  context, value.userModel!.uid);
                            }
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
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 2,
                                primary: Colors.white,
                                padding: const EdgeInsets.all(20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              onPressed: () {
                                Provider.of<UserProvider>(context,
                                        listen: false)
                                    .Login(context,value.userModel!.uid);
                              },
                              child: Image.asset(
                                Constants.imageAsset('google.png'),
                              ),
                            ),
                            const SizedBox(width: 15),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 2,
                                primary: Colors.white,
                                padding: const EdgeInsets.all(20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              onPressed: () {
                                 Provider.of<UserProvider>(context,
                                        listen: false)
                                    .loginFb(context,value.userModel!.uid);
                              },
                              child: Image.asset(
                                Constants.imageAsset('facebook.png'),
                              ),
                            ),
                          ],
                        ),
                        // Center(
                        //   child: RichText(
                        //     text: const TextSpan(children: [
                        //       TextSpan(
                        //         text: "Already have an account? ",
                        //         style: TextStyle(
                        //           color: Colors.grey,
                        //           fontSize: 13,
                        //         ),
                        //       ),
                        //       TextSpan(
                        //         text: "Sign In",
                        //         style: TextStyle(
                        //           color: Colors.black,
                        //           fontSize: 14,
                        //           fontWeight: FontWeight.w800,
                        //         ),
                        //       )
                        //     ]),
                        //   ),
                        // ),
                      ],
                    ),
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
