import 'package:flutter/material.dart';
import 'package:oi/providers/auth/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SuccessLogin extends StatefulWidget {
  const SuccessLogin({Key? key}) : super(key: key);

  @override
  _SuccessLoginState createState() => _SuccessLoginState();
}

class _SuccessLoginState extends State<SuccessLogin> {
  Future<bool> initBackButton() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: initBackButton,
      child: Scaffold(
        body: Center(
          child: Consumer<UserProvider>(
            builder: (context, value, child) {
              if (value.googlAaccount != null) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                        backgroundImage:
                            Image.network(value.googlAaccount!.photoUrl ?? '')
                                .image,
                        radius: 50),
                    Text(value.googlAaccount!.displayName ?? ''),
                    Text(value.googlAaccount!.email),
                    ActionChip(
                        avatar: Icon(Icons.logout),
                        label: Text("logout"),
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.remove('phone_number');
                          Provider.of<UserProvider>(context, listen: false)
                              .logOut(context);
                        }),
                  ],
                );
              } else if (value.userData != null) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(value.userData!["name"] ?? ''),
                    Text(">>> : " + value.userData!["email"]),
                    ActionChip(
                        avatar: Icon(Icons.logout),
                        label: Text("logout"),
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.remove('phone_number');
                          Provider.of<UserProvider>(context, listen: false)
                              .logOutFb(context);
                        }),
                  ],
                );
              } else {
                return Consumer<UserProvider>(
                  builder: (context, value, child) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(value.getuserModel!.firstname.toString()),
                          Text(value.getuserModel!.email.toString()),
                          ActionChip(
                              avatar: Icon(Icons.logout),
                              label: Text("logout"),
                              onPressed: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.remove('phone_number');
                                Provider.of<UserProvider>(context,
                                        listen: false)
                                    .logOut(context);
                              }),
                        ],
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
