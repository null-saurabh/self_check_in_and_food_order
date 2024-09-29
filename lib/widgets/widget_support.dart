import 'package:flutter/material.dart';

class AppWidget{

  static TextStyle headingBoldTextStyle(){
    return  const TextStyle(
                  color: Colors.black,
                  fontSize: 32.0,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Poppins');
  }

    static TextStyle subHeadingTextStyle(){
    return  const TextStyle(
                  color: Colors.black,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Poppins');
  }

      static TextStyle light16TextStyle(){
    return  const TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Poppins');
  }


        static TextStyle opaque16TextStyle(){
    return  const TextStyle(
                  color: Colors.black45,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Poppins');
  }


  static TextStyle bold16TextStyle(){
    return  const TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins');
  }

  static TextStyle whiteBold16TextStyle(){
    return  const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins');
  }

  static TextStyle textField16Style(){
    return  const TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins');
  }

  static TextStyle white12BoldTextStyle(){
    return  const TextStyle(
        color: Colors.white,
        fontSize: 12.0,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins');
  }
  static TextStyle white12LightTextStyle(){
    return  const TextStyle(
        color: Colors.white70,
        fontSize: 12.0,
        fontWeight: FontWeight.w400,
        fontFamily: 'Poppins');
  }

        static TextStyle semiBoldTextFieldStyle(){
    return  const TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins');
  }
}

class Validators {
  static String? requiredField(value) {
    if (value == null || value.isEmpty) {
      return "*Required";
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "*Required";
    }
    final emailRegExp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (!emailRegExp.hasMatch(value)) {
      return "Invalid email";
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return "*Required";
    }

    // Check if the phone number is a valid format (basic regex for digits)
    final phoneRegExp = RegExp(r'^[0-9]{10}$'); // Adjust regex for your specific needs

    if (!phoneRegExp.hasMatch(value)) {
      return "Invalid phone number";
    }

    return null; // Phone number is valid
  }

// You can add more custom validators here
}