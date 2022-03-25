import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({
   required this.text,
   required this.iconleading,

    Key? key,
  }) : super(key: key);

  final String text;
  final IconData iconleading;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.white24,
        onTap: () {},
        child: ListTile(
          dense: true,
          leading: Icon(
            iconleading
          ),
          title: Text(text),
          trailing: Icon(
             MaterialCommunityIcons.chevron_right
          ),
        ),
      ),
    );
  }
}
