import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:franja_rojapp/providers/ProviderInfo.dart';
import 'package:franja_rojapp/services/auth.dart';

import 'package:provider/provider.dart';

class MainAppBar extends StatefulWidget implements PreferredSizeWidget {
  MainAppBar({Key key}) : super(key: key);

  @override
  _MainAppBarState createState() => _MainAppBarState();

  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}

class _MainAppBarState extends State<MainAppBar> {
  String franjas = "...";

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<ProviderInfo>(context);
    return AppBar(
      title: Text(
        "Franja Roja",
        style: TextStyle(
            fontSize: 40,
            fontFamily: 'Silvertone',
            color: Colors.white,
            fontWeight: FontWeight.bold),
      ),
      actions: <Widget>[
        FlatButton.icon(
            icon: Icon(null),
            label: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: prov.currentProfile == null
                    ? 'Cargando...'
                    : prov.currentProfile.franjas.toString() + ' F',
                style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'Silvertone',
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ))
      ],
    );
  }

  getFranjas<String>() {
    final profiles = Provider.of<QuerySnapshot>(context);
    User firebaseUser = Auth().returnCurrentUser();
    if (profiles != null) {
      for (var doc
          in profiles.docs.where((profile) => profile.id == firebaseUser.uid)) {
        return (doc.get("franjas")).toString();
      }
    }
  }
}
