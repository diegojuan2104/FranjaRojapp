import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:franja_rojapp/components/loading.dart';
import 'package:franja_rojapp/constants/constants.dart';
import 'package:franja_rojapp/screens/main_appbar.dart';
import 'package:franja_rojapp/services/auth.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int franjas = 0;
    bool firstReward;
    return _loading
        ? Loading()
        : StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('profiles')
                .doc(Auth().firebaseUser.uid != null ? Auth().firebaseUser.uid:"loading")
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                  return Loading();
              } else {
                var userDocument = snapshot.data;
                if (userDocument != null) {
                  franjas = userDocument["franjas"];
                  firstReward = userDocument["first_reward"];
                }

                Future.delayed(Duration(milliseconds: 200), () async{
                  if(!firstReward){
                    simpleAlert(context, "Aviso", "Has ganado 10 franjas");
                    await FirebaseFirestore.instance.collection('profiles')
                    .doc(Auth().firebaseUser != null ? Auth().firebaseUser.uid:"loading")
                    .update({'first_reward': true, 'franjas': franjas + 10});
                  }
                });
              print(franjas);
              return new Scaffold(
                appBar: MainAppBar(),
                body: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("BIENVENIDO"),
                      Theme(
                        data: Theme.of(context)
                            .copyWith(accentColor: Colors.white),
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
            }
            );
  }

  _signOut() async {
    try {
      setState(() {
        _loading = true;
      });
      await Auth().signOutUser();
      Navigator.of(context).pushReplacementNamed(
        '/login',
      );
      setState(() {
        _loading = false;
      });
    } catch (e) {
      simpleAlert(context, "Aviso", "Ha ocurrido un error");
    }
  }
}
