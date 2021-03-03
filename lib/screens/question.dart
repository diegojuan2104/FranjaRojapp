import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:franja_rojapp/components/answer_button.dart';
import 'package:franja_rojapp/services/auth.dart';
import 'package:franja_rojapp/services/database.dart';

class Question extends StatefulWidget {
  Question({Key key}) : super(key: key);

  @override
  _QuestionState createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  String question;
  List answers = [];
  List users_who_responded;

  List<AnswerButton> buttonsList = new List<AnswerButton>();
  @override
  void initState() {
    super.initState();
    DatabaseService().generateRandomQuestion().then(
          (value) => {
            question = value.question,
            answers = answers + value.answers,
            users_who_responded = value.users_who_responded,
            print("QUESTION" + question.toString()),
            print("asnwers" + answers.length.toString())
          },
        );
  }

  List<Widget> _buildButtonsWithNames() {
    for (int i = 0; i < answers.length; i++) {
      buttonsList.add(AnswerButton(
          id: i, // passing the i value only, for clear int values
          label: answers[i]["text"]));
    }
    return buttonsList;
  }

  Widget build(BuildContext context) {
    return Scaffold(body: 
    Column(
      children: _buildButtonsWithNames()
    ));
  }
}
