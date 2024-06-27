import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/screens/login_screen/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

logout(BuildContext context) {
  SharedPreferences.getInstance().then((prefs) {
    prefs.clear();
    Navigator.pushReplacementNamed(context, LoginScreen.routeName);
  });
}