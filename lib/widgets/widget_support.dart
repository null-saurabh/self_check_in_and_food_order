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

  static TextStyle white12TextStyle(){
    return  const TextStyle(
        color: Colors.white,
        fontSize: 12.0,
        fontWeight: FontWeight.w600,
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