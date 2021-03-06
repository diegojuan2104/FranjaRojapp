import 'package:flutter/material.dart';
import 'package:franja_rojapp/models/QuestionModel.dart';
import 'package:franja_rojapp/providers/ProviderInfo.dart';

class AnswerButton extends StatefulWidget {
  final String label;
  final int id;
  QuestionModel question;
  Function action;
  
  Function answerSelected;

  // @required will not let user to skip the specified key to be left null
  AnswerButton(
      {@required this.label, @required this.id, @required this.question, this.answerSelected}) {}

  @override
  _AnswerButtonState createState() => _AnswerButtonState();
}

class _AnswerButtonState extends State<AnswerButton> {

  ProviderInfo prov;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
        child: SizedBox(
            width: 200,
            child: RaisedButton(
                color: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(this.widget.label),
                onPressed: () => {
                      showDialog(
                         barrierDismissible: false,
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text("Aviso"),
                                content: SingleChildScrollView(
                                    child: Container(
                                        child: Text("Has ganado 5 franjas"))),
                                actions: [
                                  FlatButton(
                                    child: Text("Aceptar"),
                                    onPressed: () {
                                      widget.answerSelected(widget.id);
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ))
                    })));
  }
}
