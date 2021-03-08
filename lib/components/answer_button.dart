import 'package:flutter/material.dart';
import 'package:franja_rojapp/constants/constants.dart';
import 'package:franja_rojapp/models/questionModel.dart';
import 'package:franja_rojapp/providers/Providerinfo.dart';

class AnswerButton extends StatefulWidget {
  final String label;
  final int id;
  QuestionModel question;
  Function action;
  Function answerSelected;

  // @required will not let user to skip the specified key to be left null
  AnswerButton(
      {@required this.label,
      @required this.id,
      @required this.answerSelected}) {}

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
        margin: EdgeInsets.only(bottom: 10),
        child: SizedBox(
            width: 200,
            child: RaisedButton(
                color: Theme.of(context).primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 15),
                textColor: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(this.widget.label),
                  ],
                ),
                onPressed: () => {
                      widget.answerSelected(widget.id),
                    })));
  }
}
