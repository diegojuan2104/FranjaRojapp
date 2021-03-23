import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:franja_rojapp/components/loading.dart';
import 'package:franja_rojapp/components/main_appbar.dart';
import 'package:franja_rojapp/constants/constants.dart';
import 'package:franja_rojapp/providers/Providerinfo.dart';
import 'package:franja_rojapp/providers/data.dart';
import 'package:franja_rojapp/services/database.dart';
import 'package:provider/provider.dart';

class PlaceDescription extends StatefulWidget {
  PlaceDescription({Key key}) : super(key: key);

  @override
  _PlaceDescriptionState createState() => _PlaceDescriptionState();
}

class _PlaceDescriptionState extends State<PlaceDescription> {
  ProviderInfo prov;
  TextEditingController descriptionController = new TextEditingController();
  bool tellStory = false;
  String placeDetails;
  int selectedRadio = 1;
  Data prov2;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    prov = Provider.of<ProviderInfo>(context);
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    prov2 = Provider.of<Data>(context);
    return loading
        ? Loading()
        : Container(
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
                                      text: tellStory
                                          ? "DESCRIBE TU HISTORIA"
                                          : "DESCRIPCIÓN DEL LUGAR",
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
                                  text: "LUGAR SELECCIONADO: " +
                                      prov.placeSelected,
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
                                          activeColor: Colors.red,
                                          onChanged: (val) {
                                            setSelectedRadio(val);
                                          },
                                        ),
                                        Text("Privada"),
                                        Radio(
                                          value: 2,
                                          groupValue: selectedRadio,
                                          activeColor: Colors.red,
                                          onChanged: (val) {
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
                              controller: descriptionController,
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
                      data:
                          Theme.of(context).copyWith(accentColor: Colors.white),
                      child: RaisedButton(
                        color: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        textColor: Colors.white,
                        onPressed: () {
                          submitDescription();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(tellStory ? "Enviar Historia" : "Continuar"),
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

  void submitDescription() async {
    if (descriptionController.text.trim() == "") {
      simpleAlert(context, "Aviso", "Ingresa detalles sobre el lugar");
      return;
    }
    if (!tellStory) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("¿Deseas contarnos tu historia? "),
                content: SingleChildScrollView(
                    child: Container(
                        child: Text(
                            "Puedes contarnos tu historia más en detalle"))),
                actions: [
                  FlatButton(
                    child: Text("No"),
                    onPressed: () async {
                      setState(() {
                        loading = true;
                      });
                      await DatabaseService().createTendederoRegister(
                          place: prov.placeSelected,
                          placeDetails: descriptionController.text,
                          story: null,
                          publicStory: null);
                      Navigator.pop(context);
                      setState(() {
                        loading = false;
                      });

                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text("Aviso"),
                                content: SingleChildScrollView(
                                    child: Container(
                                        child: Text(
                                            "Has terminado el ejercicio cartográfico"))),
                                actions: [
                                  FlatButton(
                                    child: Text("Aceptar"),
                                    onPressed: () {
                                      prov.selectedAnswer = null;

                                      Navigator.of(context)
                                          .pushNamedAndRemoveUntil('/home',
                                              (Route<dynamic> route) => false);
                                    },
                                  ),
                                ],
                              ));

                      if (!prov.currentProfile.tendedero_opened)
                        await DatabaseService().saveTendederoOpened(true);
                    },
                  ),
                  FlatButton(
                    child: Text("Si"),
                    onPressed: () {
                      setState(() {
                        placeDetails = descriptionController.text.toString();
                        tellStory = true;
                      });
                      descriptionController.text = "";
                      Navigator.pop(context);
                      simpleAlert(
                          context,
                          "Ten en cuenta de que prodrás seleccionar la privacidad de tu historia",
                          "PÚBLICA: \nTodas las personas que ingresen a FranjaRojaApp, podrán leer tu historia. \n\nPRIVADA:\nNadie podrá visualizar tu historia, a excepción del proyecto: Franja Roja: una propuesta para mitigar la violencia basada en género en el contexto de la Univerdiad de Medellín");
                    },
                  ),
                ],
              ));
    } else {
      if (descriptionController.text.trim() == "") {
        simpleAlert(context, "Aviso", "Ingresa tu historia");
        return;
      }

      bool publicStory = selectedRadio == 1 ? true : false;
      final base64String = base64Encode(prov2.imgAv);

      setState(() {
        loading = true;
      });
      await DatabaseService().createTendederoRegister(
          place: prov.placeSelected,
          placeDetails: placeDetails,
          story: descriptionController.text,
          publicStory: publicStory,
          avatarImg: base64String);
      if (!prov.currentProfile.tendedero_opened)
        await DatabaseService().saveTendederoOpened(true);
      setState(() {
        loading = false;
      });
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Aviso"),
                content: SingleChildScrollView(
                    child: Container(
                        child:
                            Text("Has terminado el ejercicio cartográfico"))),
                actions: [
                  FlatButton(
                    child: Text("Aceptar"),
                    onPressed: () {
                      descriptionController.text = "";
                      prov.selectedAnswer = null;
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/home', (Route<dynamic> route) => false);
                    },
                  ),
                ],
              ));
    }
  }

  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }
}
