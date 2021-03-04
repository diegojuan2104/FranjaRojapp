import 'package:flutter/material.dart';

class AnswerButton extends StatelessWidget {
  final String label;
  final int id;  
  Function action;

  // @required will not let user to skip the specified key to be left null
  AnswerButton({@required this.label, @required this.id, @required this.action()});

  @override
  Widget build(BuildContext context, ) {
    return Container(
      
        child: SizedBox(
          width: 200,
          child: RaisedButton(
          
            color: Colors.red,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
            ),
            child: Text(this.label),
            onPressed: () => this.action() // Here you print your id using your button only
        )
        )
        
        
    );
  }
}