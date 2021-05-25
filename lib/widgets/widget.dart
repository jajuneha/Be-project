import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context)
{
  return AppBar(
   // title: Image.asset("assets/images/logo.png", height: 50,),
    title: const Text("BE-PROJECT", style: TextStyle(
      fontSize: 18.5,
      fontWeight: FontWeight.bold,
    ),
    ),
  );
}

InputDecoration textFieldInputDecoration(String hintText)
{
  return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
          color: Colors.white54
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white)
      )
  );
}

TextStyle simpleTextStyle()
{
  return TextStyle(
      color: Colors.white,
    fontSize: 16
  );
}

TextStyle mediumTextStyle()
{
  return TextStyle(
color: Colors.white,
fontSize: 17
  );
}