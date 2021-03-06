import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:franja_rojapp/components/answer_button.dart';
import 'package:franja_rojapp/components/loading.dart';
import 'package:franja_rojapp/components/main_appbar.dart';
import 'package:franja_rojapp/models/QuestionModel.dart';
import 'package:franja_rojapp/providers/ProviderInfo.dart';
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

  String question;
  List answers = [];
  List<dynamic> users_who_responded;
  String questionId;

  int answerSelected;

  List<Widget> answer_buttons;

  var questionModel;
  List<AnswerButton> buttonsList = new List<AnswerButton>();
  @override
  void initState() {
    DatabaseService().generateRandomQuestion().then((value) => {
              this.setState(() {
                question = value.question;
                answers = value.answers;
                users_who_responded = value.users_who_responded;
                questionId = value.questionId;
              })
            
        });

    super.initState();
  }

  @override
  void dispose() {
    submitAnswer();
    super.dispose();
    // DatabaseService().addFranjas(context, prov.franjas, 5);
  }

  Widget build(BuildContext context) {
    prov = Provider.of<ProviderInfo>(context);
    return Scaffold(
      appBar: MainAppBar(),
      body:  question != "noquestions"
                ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: question != null
                ? RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: question,
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                : Loading(),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
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
      ): Center(
        child: Text("No hay más preguntas de momento"),
      ),
    );
  }

  List<Widget> _buildButtonsWithNames() {
    if (buttonsList.length == 0) {
      for (int i = 0; i < answers.length; i++) {
        buttonsList.add(
          AnswerButton(
              id: i, // passing the i value only, for clear int values
              label: answers[i]["text"],
              question: new QuestionModel(
                  answers: answers,
                  question: question,
                  users_who_responded: users_who_responded),
              answerSelected: (int answer) {
                setState(() {
                  answerSelected = answer;
                });
              }),
        );
      }
    }
    return buttonsList;
  }

  submitAnswer() async {
    answers[answerSelected]["counter"] += 1;
    users_who_responded.add(Auth().firebaseUser.uid.toString());
    await DatabaseService()
        .updateQuestion(answers, users_who_responded, questionId);
    await FirebaseFirestore.instance
        .collection('profiles')
        .doc(Auth().firebaseUser != null ? Auth().firebaseUser.uid : "loading")
        .update({'franjas': prov.currentProfile.franjas + 5});
    DatabaseService().getCurrentProfile();
  }

  updateAnswerScore(int idAnswer) {
    print("ANSWER SELECTED" + idAnswer.toString());
  }


}
