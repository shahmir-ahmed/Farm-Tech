import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Utils {
  // colors
  static const Color whiteColor = Colors.white;
  static const Color greenColor = Color(0xff339D44);
  static const Color blackColor1 = Color(0xff292929);
  static const Color lightGreyColor1 = Color(0xffB4B4B4);
  static const Color lightGreenColor1 = Color(0xffb8ddbe);

  // text styles
  static final TextStyle kAppBody1RegularStyle =
      GoogleFonts.raleway(fontSize: 19.2);
  static final TextStyle kAppBody2RegularStyle =
      GoogleFonts.raleway(fontSize: 16);
  static final TextStyle kAppBody2BoldStyle =
      GoogleFonts.raleway(fontSize: 16, fontWeight: FontWeight.bold);
  static final TextStyle kAppBody3RegularStyle =
      GoogleFonts.raleway(fontSize: 13.33);
  static final TextStyle kAppBody3MediumStyle =
      GoogleFonts.raleway(fontSize: 13.3, fontWeight: FontWeight.w500);
  static final TextStyle kAppHeading4BoldStyle =
      GoogleFonts.raleway(fontSize: 33.2, fontWeight: FontWeight.bold);
  static final TextStyle kAppHeading5BoldStyle =
      GoogleFonts.raleway(fontSize: 27.6, fontWeight: FontWeight.bold);
  static final TextStyle kAppHeading6BoldStyle =
      GoogleFonts.raleway(fontSize: 23, fontWeight: FontWeight.bold);

  // text form field decoration
  static final inputFieldDecoration = InputDecoration(
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Utils.greenColor,
          ),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      hintText: '',
      hintStyle: Utils.kAppBody3RegularStyle,
      contentPadding: const EdgeInsets.all(26),
      border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Utils.lightGreyColor1,
          ),
          borderRadius: BorderRadius.all(Radius.circular(20))));
}
