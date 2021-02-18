import 'package:flutter/material.dart';
import 'package:franja_rojapp/services/auth.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[ Theme(
                data: Theme.of(context).copyWith(accentColor: Colors.white),
                child: RaisedButton(
                  color: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  textColor: Colors.white,
                  onPressed: () async => _signOut(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Cerrar sesión"),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }


  _signOut() {
    Auth().signOutUser();
  }
}
