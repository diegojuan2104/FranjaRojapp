import 'package:flutter/material.dart';
import 'package:franja_rojapp/components/main_appbar.dart';
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          CircleAvatar(
            radius: 60.0,
            backgroundImage: NetworkImage(
                'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png'),
            backgroundColor: Colors.transparent,
          ),
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
          Theme(
            data: Theme.of(context).copyWith(accentColor: Colors.white),
            child: RaisedButton(
              color: Theme.of(context).primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 15),
              textColor: Colors.white,
              onPressed: () async => _createQuestion(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Test"),
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

  //TEST
  _createQuestion() {
    String question = "a question?";
    List<Map> answers = [
      {
        "text": "Si",
        "counter": 0,
      },
      {
        "text": "No",
        "counter": 0,
      },
      {
        "text": "No sé",
        "counter": 0,
      }
    ];
    List<String> usersWhoresponded = [];

    DatabaseService().createAQuestion(question, answers, usersWhoresponded);
    //DatabaseService().generateRandomQuestion();
  }
}
