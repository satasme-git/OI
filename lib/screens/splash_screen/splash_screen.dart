import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oi/componants/custom_text.dart';
import 'package:oi/screens/login_screen/example2.dart';
import 'package:oi/utils/constatnt.dart';
import 'package:oi/utils/util_funtions.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      // Navigator.push(
      //   context,
      //   PageTransition(
      //       child: const AddPhoneNumber(),
      //       childCurrent: const SplashScreen(),
      //       type: PageTransitionType.rightToLeftJoined,
      //       duration: const Duration(milliseconds: 500),
      //       // reverseDuration: const Duration(milliseconds: 500),
      //       curve: Curves.easeInCubic,
      //       alignment: Alignment.topCenter),
      // );
      UtilFuntions.navigateTo(context, Example2());
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: Colors.black,
        height: size.height,
        width: size.width,
        child: Column(
          children: [
            SizedBox(
              height: size.height / 2.3,
            ),
            Image.asset(
              Constants.imageAsset("iologo.png"),
            ),
            const SizedBox(
              height: 10,
            ),
            const SpinKitRing(
              color: Colors.white,
              size: 28.0,
              lineWidth: 2,
            ),
            const SizedBox(
              height: 10,
            ),
            const CustomText(
              text: "loading informations...",
              color: Colors.white,
              fontsize: 12,
            ),
          ],
        ),
      ),
    );
  }
}
