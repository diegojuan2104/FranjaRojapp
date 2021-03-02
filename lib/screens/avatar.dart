import 'package:flutter/material.dart';
import 'package:franja_rojapp/screens/main_appbar.dart';
import 'package:franja_rojapp/services/database.dart';

class Avatar extends StatefulWidget {
  Avatar({Key key}) : super(key: key);

  @override
  _AvatarState createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
          body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Theme(
            data: Theme.of(context).copyWith(accentColor: Colors.white),
            child: RaisedButton(
              color: Theme.of(context).primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 15),
              textColor: Colors.white,
              onPressed: () async => _saveAvatar(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Guardar Avatar"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _saveAvatar() {
    DatabaseService().saveAvatarCreated(context, true);
  }
}
