import 'package:flutter/material.dart';

import '../../../../utils/constatnt.dart';


class CircleImageAvatar extends StatelessWidget {
  const CircleImageAvatar({
    Key? key,
    required this.radius,
    this.selector=true,
  }) : super(key: key);

final double radius;
final bool selector;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius:radius,
      backgroundColor: Colors.white,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(55),
            child: Image.asset(
              Constants.imageAsset('profile.png'),
              // width: 170.0,
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.only(right: 0, bottom: 0),
          Align(
            alignment: Alignment.bottomRight,
            child: selector==true? Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey,
              ),
              child: Icon(
                Icons.edit,
                color: Colors.white,
              ),
            ):null ,
          ),
          // )
        ],
      ),
    );
  }
}
