import 'package:flutter/material.dart';
import 'package:franja_rojapp/components/grid_menu.dart';
import 'package:franja_rojapp/components/main_appbar.dart';
import 'package:franja_rojapp/services/database.dart';

class Tendedero extends StatefulWidget {
  Tendedero({Key key}) : super(key: key);

  @override
  _TendederoState createState() => _TendederoState();
}

class _TendederoState extends State<Tendedero> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    return Container(
      child: Scaffold(
        appBar: MainAppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: queryData.size.height * 0.15,
              ),
              Container(
                color: Colors.white,
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: "Tendedero ¿Qué putas Estás Callando?",
                        style: TextStyle(
                          fontSize: 35,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'DancingScript',
                        ),
                      ),
                    )),
              ),
              Container(
                padding: EdgeInsets.all(15),
                child: GridView.count(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  children: <Widget>[
                    GridMenu(
                      title: "Ejercicio Cartográfico",
                      icon: Icons.map,
                      warna: Colors.red,
                      action: () {
                        Navigator.of(context)
                            .pushNamed("/cartographic_exercise");
                      },
                    ),
                    GridMenu(
                      title: "Historias",
                      icon: Icons.library_books,
                      warna: Colors.red,
                      action: () {
                        Navigator.of(context).pushNamed("/stories");
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
