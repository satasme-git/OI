import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SliverTest extends StatelessWidget {
  const SliverTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.white,
          ),
          backgroundColor: Colors.white,
          title: Text(
            'facebook',
          ),
          centerTitle: false,
          floating: true,
          leading: Icon(Icons.plus_one),
          actions: [
            Container(
              margin: EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                  color: Colors.grey[200], shape: BoxShape.circle),
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.arrow_back),
                iconSize: 15,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ],
    ));
  }
}
