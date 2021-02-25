import 'package:flutter/material.dart';
import 'package:franja_rojapp/constants/constants.dart';
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
          children: <Widget>[ 
            
            Text("BIENVENIDO"),
            Theme(
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


  _signOut()  async {
    try{
      await Auth().signOutUser();
    }catch(e){
      simpleAlert(context, "Aviso", "Ha ocurrido un error");
    }
  }
}
