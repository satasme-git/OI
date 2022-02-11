import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:oi/utils/app_colors.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    required this.text,
    this.fontsize = 15,
    this.color = primaryTxtColor,
    this.fontWeight,
    this.textAlign,
    Key? key,
  }) : super(key: key);

  final String text;
  final double fontsize;
  final Color color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: textAlign,
        style: GoogleFonts.poppins(
          fontSize: fontsize,
          color: color,
          fontWeight: fontWeight,
        ));
  }
}
//  style: GoogleFonts.poppins(
//         fontSize: fontsize,
//         color: color,
//         fontWeight: fontWeight,
//       ),