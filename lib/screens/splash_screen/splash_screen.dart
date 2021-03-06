import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:oi/componants/custom_text.dart';
import 'package:oi/providers/auth/user_provider.dart';
import 'package:oi/utils/constatnt.dart';
import 'package:provider/provider.dart';

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
      Provider.of<UserProvider>(context, listen: false).initializeUser(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                Color.fromRGBO(247, 148, 29, 1),
                Color.fromRGBO(254, 203, 48, 1),
                // Colors.blue,
                // Colors.purple,
              ],
            ),
          ),
        // color: Colors.black,
        height: size.height,
        width: size.width,
        child: Column(
          children: [
            SizedBox(
              height: size.height / 2.3,
            ),
            Image.asset(
              Constants.imageAsset("iologo1.png"),
              scale: 1.5,
            ),
            const SizedBox(
              height: 10,
            ),
            const SpinKitRing(
              color: Colors.black,
              size: 28.0,
              lineWidth: 2,
            ),
            const SizedBox(
              height: 10,
            ),
            const CustomText(
              text: "loading informations...",
              color: Colors.black,
              fontsize: 12,
            ),
          ],
        ),
      ),
    );
  }
}
