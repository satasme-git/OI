import 'package:flutter/material.dart';
import 'package:oi/google_login_controller.dart';
import 'package:provider/provider.dart';
import 'utils/constatnt.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("socail login"),
        backgroundColor: Colors.redAccent,
      ),
      body: loginUI(),
    );
  }

  loginUI() {
    return Consumer<GoogleSignInController>(
      builder: (context, model, child) {
        if (model.googleAccount != null) {
          return Center(
            child: logedInUI(model),
          );
        } else {
          return LoginControls(context);
        }
      },
    );
  }

  logedInUI(GoogleSignInController model) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
            backgroundImage:
                Image.network(model.googleAccount!.photoUrl ?? '').image,
            radius: 50),
        Text(model.googleAccount!.displayName ?? ''),
        Text(model.googleAccount!.email),
        ActionChip(
            avatar: Icon(Icons.logout),
            label: Text("logout"),
            onPressed: () {
              Provider.of<GoogleSignInController>(context, listen: false)
                  .logOut();
            })
      ],
    );
  }

  LoginControls(BuildContext context) {
    return Center(
      child: Row(
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
              Provider.of<GoogleSignInController>(context,listen: false).login();
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
            onPressed: () {},
            child: Image.asset(
              Constants.imageAsset('facebook.png'),
            ),
          ),
        ],
      ),
    );
  }
}
