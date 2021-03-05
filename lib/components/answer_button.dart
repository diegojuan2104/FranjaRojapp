import 'package:flutter/material.dart';
import 'package:franja_rojapp/models/questionModel.dart';
import 'package:franja_rojapp/providers/Providerinfo.dart';
import 'package:franja_rojapp/services/database.dart';
import 'package:provider/provider.dart';

class AnswerButton extends StatefulWidget {
  final String label;
  final int id;
  QuestionModel question;

  // @required will not let user to skip the specified key to be left null
  AnswerButton(
      {@required this.label, @required this.id, @required this.question}){
        
        
      }

  @override
  _AnswerButtonState createState() => _AnswerButtonState();
}

class _AnswerButtonState extends State<AnswerButton> {

  @override
  void initState() {
    // widget.question.answers[id]["counter"] +=1;
    //     print(widget.question.answers[id]["counter"].toString());
    super.initState();
  }
  @override
  Widget build(
    BuildContext context,
  ) {
    var prov = Provider.of<ProviderInfo>(context);
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
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text("Aviso"),
                                content: SingleChildScrollView(
                                    child: Container(
                                        child: Text("Has ganado 5 franjas" +
                                            widget.question.answers[widget.id]["counter"]
                                                .toString()))),
                                actions: [
                                  FlatButton(
                                    child: Text("Aceptar"),
                                    onPressed: () {
                                      

                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              ))
                      // Here you print your id using your button only
                    })));
  }
}
