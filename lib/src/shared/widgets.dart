import 'package:flutter/material.dart';
import 'package:lively/src/shared/constants.dart';
import 'package:lively/src/shared/ui_helper.dart';

const textDecoration = InputDecoration(
  labelStyle: TextStyle(color: Colors.black),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: primaryColor,
      width: 2,
    ),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: primaryColor,
      width: 2,
    ),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: primaryColor,
      width: 2,
    ),
  ),
);

void nextScreen(BuildContext context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void nextScreenReplacement(BuildContext context, page) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => page));
}

void shoeSnackbar(BuildContext context, message, color) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    behavior: SnackBarBehavior.floating,
    content: Text(message, style: const TextStyle(
      fontSize: UIHelper.kMediumFont,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    ),),
    backgroundColor: color,
    duration: const Duration(milliseconds: 2500),
    action: SnackBarAction(label: 'OK', onPressed: (){}, textColor: Colors.white,),
  ));
}
