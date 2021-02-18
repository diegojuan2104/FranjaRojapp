import 'package:flutter/material.dart';
import 'package:franja_rojapp/screens/home.dart';
import 'package:franja_rojapp/screens/login.dart';
import 'package:franja_rojapp/models/user_model.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User_model>(context);
    print("WRAPPER"+user.toString());
    //Return home or authenticate widget 
    if(user == null){
      return Login();
    }else{
      return Home();
    }
  }
}