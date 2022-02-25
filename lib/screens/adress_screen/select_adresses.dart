import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:oi/utils/util_funtions.dart';

class SelectAddress extends StatelessWidget {
  const SelectAddress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(
                MaterialCommunityIcons.arrow_left,
                color: Colors.black,
              ),
              onPressed: () {
                UtilFuntions.goBack(context);
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 65,
              // height: 50,
              // color: Colors.amber,
              child: Column(
                
                children: [
                  SizedBox(height: 10,),
                  Text(
                    "Pickup",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  Container(
                    height: 6,
                    width: 6,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  SizedBox(
                    height: 1,
                  ),
                  Container(
                    height: 15,
                    width: 0.5,
                    decoration: BoxDecoration(
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 1,
                  ),
                  Container(
                    height: 6,
                    width: 6,
                    decoration: BoxDecoration(
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "Drop",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber[800],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                // width: 20,
                // height: 30,
                // color: Colors.red,
                child: Column(
                  children: [
                    Container(
                      height: 40,
                      color: Colors.grey[100],
                      child: TextField(
                        onTap: () {
                          // UtilFuntions.pageTransition(
                          //     context, SelectAddress(), MapSample());
                        },
                        // enabled: false, //Not clickable and not editable
                        readOnly: true,
                        decoration: const InputDecoration(
                          hintStyle: TextStyle(fontSize: 17),
                          hintText: 'Your Location',
                          suffixIcon: Align(
                            widthFactor: 1.0,
                            heightFactor: 1.0,
                            child: Icon(MaterialCommunityIcons.heart_outline),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(5),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      height: 40,
                      color: Colors.grey[100],
                      child: const TextField(
                        decoration: InputDecoration(
                          hintStyle: TextStyle(fontSize: 17),
                          hintText: 'Where are you going',
                          suffixIcon: Align(
                            widthFactor: 1.0,
                            heightFactor: 1.0,
                            child: Icon(MaterialCommunityIcons.plus),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(5),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
