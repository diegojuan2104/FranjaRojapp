import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:franja_rojapp/screens/menu/home.dart';
import 'package:franja_rojapp/screens/authentication/login.dart';
import 'package:franja_rojapp/models/userModel.dart';
import 'package:franja_rojapp/services/auth.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  final MaterialColor kPrimaryColor = const MaterialColor(
    0xFFfC2c2C,
    const <int, Color>{
      50: Color(0xFFFFEBEE),
      100: Color(0xFFFFCDD2),
      200: Color(0xFFEF9A9A),
      300: Color(0xFFE57373),
      400: Color(0xFFEF5350),
      500: Color(0xFFfC2c2C),
      600: Color(0xFFE53935),
      700: Color(0xFFD32F2F),
      800: Color(0xFFC62828),
      900: Color(0xFFB71C1C),
    },
  );
  @override
  Widget build(BuildContext context) {
    User firebaseUser = Auth().returnCurrentUser();
    //Return home or authenticate widget
    if (firebaseUser != null) {
      return Auth().emailIsVerified() ? Login() : Home();
    }else{
      return Login();
    }
  }
}
