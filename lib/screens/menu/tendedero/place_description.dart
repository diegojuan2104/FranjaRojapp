import 'package:flutter/material.dart';
import 'package:franja_rojapp/components/main_appbar.dart';
import 'package:franja_rojapp/providers/Providerinfo.dart';
import 'package:provider/provider.dart';

class PlaceDescription extends StatefulWidget {
  PlaceDescription({Key key}) : super(key: key);

  @override
  _PlaceDescriptionState createState() => _PlaceDescriptionState();
}

class _PlaceDescriptionState extends State<PlaceDescription> {
  ProviderInfo prov;
  TextEditingController desriptionController = new TextEditingController();
  bool tellStory = false;
  String placeDetails;
  int selectedRadio = 0;

  @override
  Widget build(BuildContext context) {
    prov = Provider.of<ProviderInfo>(context);
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return Container(
        child: Scaffold(
      appBar: MainAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: queryData.size.height * 0.15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: "LA UDEM YA NO CALLA",
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'BigShouldersDisplay',
                                ),
                              ),
                            )),
                      ],
                    ),
                    Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: "LUGAR SELECCIONADO: " + prov.placeSelected,
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'BigShouldersDisplay',
                            ),
                          ),
                        )),
                    tellStory
                        ? Row(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text("Pública"),
                                  Radio(
                                    value: 1,
                                    groupValue: selectedRadio,
                                    activeColor: Colors.green,
                                    onChanged: (val) {
                                      print("Radio $val");
                                      setSelectedRadio(val);
                                    },
                                  ),
                                  Text("Privada"),
                                  Radio(
                                    value: 2,
                                    groupValue: selectedRadio,
                                    activeColor: Colors.blue,
                                    onChanged: (val) {
                                      print("Radio $val");
                                      setSelectedRadio(val);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          )
                        : SizedBox(
                            height: 0,
                          ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: queryData.size.width * 0.8,
                      child: TextField(
                        controller: desriptionController,
                        maxLines: 5,
                        decoration: InputDecoration(
                            hintText: tellStory
                                ? "Cuentanos tu historia"
                                : "Descripción del lugar",
                            border: OutlineInputBorder(),
                            labelText: tellStory
                                ? "Describe tu historia"
                                : 'Describe el lugar más específicamente'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: queryData.size.width * 0.8,
              child: Theme(
                data: Theme.of(context).copyWith(accentColor: Colors.white),
                child: RaisedButton(
                  color: Theme.of(context).primaryColor,
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  textColor: Colors.white,
                  onPressed: () {
                    submitDescription();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Continuar"),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }

  void submitDescription() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("¿Deseas contarnos tu historia? "),
              content: SingleChildScrollView(
                  child: Container(
                      child: Text(
                          "Cuentanos tu historia: Puedes contarnos tu historia más en detalle"))),
              actions: [
                FlatButton(
                  child: Text("No"),
                  onPressed: () {
                    setState(() {});
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("Si"),
                  onPressed: () {},
                ),
              ],
            ));
  }

  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }
}
