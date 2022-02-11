import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    Key? key,
    this.hintext,
    this.labeltext,
    this.controller,
  }) : super(key: key);
  final String? hintext;
  final String? labeltext;
  final TextEditingController? controller;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  String? validatePass(value) {
    if (value.isEmpty) {
      return "ssss";
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator:validatePass,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(15),
        hintText: widget.hintext, //"Enter first name here",
        labelText: widget.labeltext, //"First Name",
        fillColor: Colors.red,
        labelStyle: GoogleFonts.poppins(
          color: Colors.black,
          fontSize: 12,
        ),

        border: OutlineInputBorder(
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
