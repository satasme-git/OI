import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:oi/providers/auth/sign_up_provider.dart';
import 'package:oi/providers/auth/timer_provider.dart';
import 'package:oi/providers/auth/user_provider.dart';
import 'package:oi/screens/adress_screen/search_address2.dart';
import 'package:oi/screens/adress_screen/select_adresses.dart';
import 'package:provider/provider.dart';
import 'providers/auth/otp_provider.dart';
import 'screens/home_screen/map_screen.dart';
import 'screens/splash_screen/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => OTPProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SignUpProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => TimerProvider(),
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IO',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MapSample(),
    );
  }
}
