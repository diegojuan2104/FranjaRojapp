import 'package:flutter/material.dart';
import 'package:franja_rojapp/constants/constants.dart';

class GlosaryCard extends StatelessWidget {
  final String title;
  final String content;
  final String example;
  final int index;
  final int total;

  const GlosaryCard(
      {Key key,
      String this.title,
      String this.content,
      String this.example,
      int this.index,
      int this.total})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Container(
      margin: EdgeInsets.all(3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: SingleChildScrollView(
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: title,
                      style: TextStyle(
                        fontSize: 70,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Silvertone',
                      ),
                    ),
                  )),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: content,
                  style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'BigShouldersDisplay',
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              SizedBox(
                  width: 200,
                  child: Theme(
                    data: Theme.of(context).copyWith(accentColor: Colors.white),
                    child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      textColor: Colors.white,
                      onPressed: () {
                        simpleAlert(context, "Ejemplo", "Ejemplo");
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Ejemplo"),
                        ],
                      ),
                    ),
                  )),
              SizedBox(
                height: 40,
              ),
              Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: index.toString() + "/" + total.toString(),
                      style: TextStyle(
                        fontSize: 50,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Silvertone',
                      ),
                    ),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Puedes deslizar >>",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
