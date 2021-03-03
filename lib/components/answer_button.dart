import 'package:flutter/material.dart';

class AnswerButton extends StatelessWidget {
  final String label;
  final int id;  // this will save your day

  // @required will not let user to skip the specified key to be left null
  AnswerButton({@required this.label, @required this.id});

  @override
  Widget build(BuildContext context) {
    return Container(
       child: Center(
        child: RaisedButton(
            color: Colors.red,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
            ),
            child: Text(this.label),
            onPressed: () => print(this.id) // Here you print your id using your button only
        )
    ));
  }
}