import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:franja_rojapp/components/answer_button.dart';
import 'package:franja_rojapp/components/loading.dart';
import 'package:franja_rojapp/constants/constants.dart';

import 'package:franja_rojapp/services/database.dart';
import 'package:provider/provider.dart';

import '../../providers/Providerinfo.dart';

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
  TextEditingController openAnswerController = new TextEditingController();
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
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    prov = Provider.of<ProviderInfo>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
      ),
      body: question != "noquestions"
          ? question != null
              ? SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: queryData.size.height * 0.05,
                      ),
                      Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: "Cuentanos!",
                              style: TextStyle(
                                fontSize: 80,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Silvertone',
                              ),
                            ),
                          )),
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
                      openQuestion
                          ? (Container(
                              width: queryData.size.width * .8,
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: queryData.size.height * 0.03,
                                  ),
                                  TextField(
                                    keyboardType: intInputType
                                        ? TextInputType.number
                                        : TextInputType.text,
                                    inputFormatters: intInputType
                                        ? <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ]
                                        : null,
                                    controller: openAnswerController,
                                    maxLines: 2,
                                    decoration: InputDecoration(
                                        hintText: "Ingresa tu respuesta",
                                        border: OutlineInputBorder(),
                                        labelText: 'Respuesta'),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Theme(
                                    data: Theme.of(context)
                                        .copyWith(accentColor: Colors.white),
                                    child: RaisedButton(
                                      color: Theme.of(context).primaryColor,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15),
                                      textColor: Colors.white,
                                      onPressed: () async {
                                        await submitAnswer(context);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text("Enviar respuesta"),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ))
                          : SizedBox(
                              height: 0,
                            ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: _buildAnswerButtonsWith(),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              : Loading()
          : Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Has contestado todas las preguntas!",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Theme(
                            data: Theme.of(context)
                                .copyWith(accentColor: Colors.white),
                            child: RaisedButton(
                              color: Theme.of(context).primaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              textColor: Colors.white,
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("Regresar"),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
    );
  }

  List<Widget> _buildAnswerButtonsWith() {
    if (question != null && answers != null) {
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
                  submitAnswer(context);
                }),
          );
        }
      }
    }
    return buttonsList;
  }

  submitAnswer(context) async {
    if (answerSelected != null || openQuestion) {
      if (openQuestion) {
        if (openAnswerController.text == "") {
          simpleAlert(context, "Aviso", "Debes escribir una respuesta");

          return;
        }
      }
      moreQuestions(context, franjas);
      await DatabaseService().createAnswerRegister(
        openQuestion ? openAnswerController.text : answers[answerSelected],
        questionId,
        question,
        prov.currentProfile.questionsAnswered,
      );
      await DatabaseService()
          .addFranjas(context, prov.currentProfile.franjas, franjas);
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
}
