import 'package:flutter/material.dart';
import 'package:franja_rojapp/components/answer_button.dart';
import 'package:franja_rojapp/components/loading.dart';
import 'package:franja_rojapp/components/main_appbar.dart';
import 'package:franja_rojapp/providers/ProviderInfo.dart';

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
  String questionId;
  int franjas;
  bool intInputType;
  bool openQuestion;
  int answerSelected;
  List<Widget> answer_buttons;

  var questionModel;
  List<AnswerButton> buttonsList = new List<AnswerButton>();
  @override
  void initState() {
    getQuestionData();
    super.initState();
  }

  @override
  void dispose() {
    if (this.mounted) {
      super.dispose();
    }
  }

  Widget build(BuildContext context) {
    prov = Provider.of<ProviderInfo>(context);
    return Scaffold(
      appBar: MainAppBar(),
      body: question != "noquestions"
          ? question != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: question,
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
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
                                children: openQuestion
                                    ? <Widget>[
                                        Theme(
                                          data: Theme.of(context).copyWith(
                                              accentColor: Colors.white),
                                          child: RaisedButton(
                                            color:
                                                Theme.of(context).primaryColor,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 15),
                                            textColor: Colors.white,
                                            onPressed: () {},
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text("Enviar respuesta"),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ]
                                    : _buildButtonsWithNames(),
                              ),
                            ],
                          )
                        ]),
                  ],
                )
              : Loading()
          : Center(
              child: Text("No hay más preguntas de momento"),
            ),
    );
  }

  List<Widget> _buildButtonsWithNames() {
    if (question != null) {
      if (buttonsList.length == 0) {
        for (int i = 0; i < answers.length; i++) {
          buttonsList.add(
            AnswerButton(
                id: i, // passing the i value only, for clear int values
                label: answers[i],
                answerSelected: (int answer) {
                  setState(() {
                    answerSelected = answer;
                  });
                  submitAnswer();
                }),
          );
        }
      }
    }
    return buttonsList;
  }

  submitAnswer() async {
    if (answerSelected != null) {
      await DatabaseService().createAnswerRegister(
        answers[answerSelected],
        questionId,
        question,
        prov.currentProfile.questionsAnswered,
      );
      await DatabaseService()
          .addFranjas(context, prov.currentProfile.franjas, franjas);
      await DatabaseService().getCurrentProfile();
    }
  }

  getQuestionData() async {
    await DatabaseService().getQuestionData().then((value) => {
          this.setState(() {
            question = value.question;
            answers = value.answers;
            questionId = value.questionId;
            franjas = value.franjas;
            intInputType = value.intInputType;
            openQuestion = value.openQuestion;
          }),
        });
  }

  getQuestionsAlreadyAnswered() {}

  updateAnswerScore(int idAnswer) {
    print("ANSWER SELECTED" + idAnswer.toString());
  }
}
