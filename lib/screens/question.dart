import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:franja_rojapp/components/answer_button.dart';
import 'package:franja_rojapp/components/loading.dart';
import 'package:franja_rojapp/components/main_appbar.dart';
import 'package:franja_rojapp/providers/Providerinfo.dart';
import 'package:franja_rojapp/services/auth.dart';
import 'package:franja_rojapp/services/database.dart';
import 'package:provider/provider.dart';

class Question extends StatefulWidget {
  Question({Key key}) : super(key: key);

  @override
  _QuestionState createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  ProviderInfo prov;
  String questionr;
  List answers = [];
  List users_who_responded;
  List<Widget> answer_buttons;
  bool buttons_setted = false;
  var questionModel;
  List<AnswerButton> buttonsList = new List<AnswerButton>();
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    prov = Provider.of<ProviderInfo>(context);
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('questions').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Loading();
          } else {
            var questionCollection = snapshot.data;
            generateQuestion(questionCollection);
            return Scaffold(
              appBar: MainAppBar(),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: questionr != null
                        ? RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: questionr,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        : Loading(),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Column(
                              children: _buildButtonsWithNames(),
                            ),
                          ],
                        )
                      ]),
                ],
              ),
            );
          }
        });
  }

  List<Widget> _buildButtonsWithNames() {
    buttonsList.clear();
    for (int i = 0; i < answers.length; i++) {
      buttonsList.add(
        AnswerButton(
            id: i, // passing the i value only, for clear int values
            label: answers[i]["text"],
            action: submitAnswer),
      );
    }
    return buttonsList;
  }

  generateQuestion(snap) {
    if (questionr == null) {
      Future.delayed(Duration(milliseconds: 200), () async {
        for (int i = 0; i < snap.docs.length; i++) {
          users_who_responded = snap.docs[i].get("users_who_responded");
          //Verify if the user had answer that question
          if (!users_who_responded.contains(Auth().firebaseUser.uid)) {
            if (this.mounted) {
              setState(() {
                questionr = snap.docs[i].get("question");
                answers = snap.docs[i].get("answers");
                users_who_responded = snap.docs[i].get("users_who_responded");
              });
            }
            break;
          }
        }
      });
    }
  }

  submitAnswer() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Aviso"),
              content: SingleChildScrollView(
                  child: Container(child: Text("Has ganado 5 franjas"))),
              actions: [
                FlatButton(
                  child: Text("Aceptar"),
                  onPressed: () {
                    setState(() {});
                    DatabaseService().addFranjas(context, prov.franjas, 5);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            ));
  }
}
