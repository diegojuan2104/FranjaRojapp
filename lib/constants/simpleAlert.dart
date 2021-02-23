import 'package:flutter/material.dart';

simpleAlert(context, title, text){
   showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(title),
              content: SingleChildScrollView(
                  child: Container(
                      child: Text(text))),
              actions: [
                FlatButton(
                  child: Text("Aceptar"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
}