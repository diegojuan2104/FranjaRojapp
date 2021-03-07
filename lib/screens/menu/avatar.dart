import 'package:flutter/material.dart';
import 'package:franja_rojapp/components/main_appbar.dart';
import 'package:franja_rojapp/models/QuestionModel.dart';
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
  _createQuestion() async{
    String question = "¿Conoces la Política de Inclusión y de Reconocimiento de la Diversidad en la Universidad de Medellín?";
    List sino = [
      "Si","No"
    ];

    List sinonose = [
      "Si","No","No sé"
    ];


    List<QuestionModel> questions = [
    //    QuestionModel(
    //   answers: sino,
    //   question: "A" ,
    // ),

    //  QuestionModel(
    //   answers: sino,
    //   question: "B" ,
    // ),
    QuestionModel(
      openQuestion: true,
      question: "C" ,
    ),

    ];

    questions.forEach((element) async {
       await DatabaseService().createAQuestion(element);
    });
    //DatabaseService().generateRandomQuestion();
  }
}
