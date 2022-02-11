import 'package:flutter/material.dart';
import 'package:oi/facebook_login_controller.dart';
import 'package:oi/utils/constatnt.dart';
import 'package:provider/provider.dart';

class FacebookLoginPage extends StatefulWidget {
  const FacebookLoginPage({ Key? key }) : super(key: key);

  @override
  _FacebookLoginPageState createState() => _FacebookLoginPageState();
}

class _FacebookLoginPageState extends State<FacebookLoginPage> {
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
    return Consumer<FacebookSignInController>(
      builder: (context, model, child) {
        if (model.userData != null) {
          return Center(
            child: logedInUI(model),
          );
        } else {
          return LoginControls(context);
        }
      },
    );
  }

  logedInUI(FacebookSignInController model) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // CircleAvatar(
        //     backgroundImage:
        //         Image.network(model.userData![] ?? '').image,
        //     radius: 50),
        Text(model.userData!["name"] ?? ''),
        Text(model.userData!["email"]),
        ActionChip(
            avatar: Icon(Icons.logout),
            label: Text("logout"),
            onPressed: () {
              Provider.of<FacebookSignInController>(context, listen: false)
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
              Provider.of<FacebookSignInController>(context,listen: false).login();
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