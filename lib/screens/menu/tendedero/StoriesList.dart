import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: MainAppBar(),
      body: Container(
          child: ListView.builder(
        itemCount: listStory.length,
        itemBuilder: (context, index) {
          Map data = listStory[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Card(
                child: ListTile(
                    title: Text(data["story"],
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black)),
                    subtitle: Text(data["date"]),
                    ),
              ),
            ),
          );
        },
      )),
    );
  }
}
