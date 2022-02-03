import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
     this.hintext,
     this.labeltext,
    // this.controller,
  }) : super(key: key);
final String? hintext;
final String? labeltext;
// final TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    return TextField(
      // controller: controller,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(15),
        hintText: hintext,//"Enter first name here",
        labelText: labeltext,//"First Name",
        fillColor: Colors.red,
        labelStyle: GoogleFonts.poppins(
          color: Colors.black,
          fontSize: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}