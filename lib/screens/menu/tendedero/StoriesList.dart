import 'package:flutter/material.dart';
import 'package:franja_rojapp/components/loading.dart';
import 'package:franja_rojapp/components/main_appbar.dart';
import 'package:franja_rojapp/services/database.dart';

class Stories extends StatefulWidget {
  Stories({Key key}) : super(key: key);

  @override
  _StoriesState createState() => _StoriesState();
}

class _StoriesState extends State<Stories> {
  List listStory;
  @override
  void initState() {
    DatabaseService().getTendedero("").then((value) => this.setState(() {
          listStory = value;
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return listStory == null
        ? Loading()
        : Scaffold(
            appBar: MainAppBar(),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: "Historias",
                          style: TextStyle(
                            fontSize: 50,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'DancingScript',
                          ),
                        ),
                      )),
                  listStory.length == 0
                      ? Text(
                          "No hay historias para mostrar en el momento",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )
                      : ListView.builder(
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: listStory.length,
                          itemBuilder: (context, index) {
                            Map data = listStory[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Card(
                                  child: Column(
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: RichText(
                                            textAlign: TextAlign.center,
                                            text: TextSpan(
                                              text: data["place"],
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontFamily:
                                                    'BigShouldersDisplay',
                                              ),
                                            ),
                                          )),
                                      ListTile(
                                        title: Text(data["story"],
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black)),
                                        subtitle: Text(data["date"].toString()),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
          );
  }
}
