import 'package:flutter/material.dart';
import 'package:franja_rojapp/components/main_appbar.dart';
import 'package:franja_rojapp/constants/constants.dart';
import 'package:franja_rojapp/providers/Providerinfo.dart';
import 'package:franja_rojapp/providers/data.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

class CartographicExercise extends StatefulWidget {
  CartographicExercise({Key key}) : super(key: key);

  @override
  _CartographicExerciseState createState() => _CartographicExerciseState();
}

dynamic valueChoosed;
bool valueChoosedAndAcepted = false;
ProviderInfo prov;

class _CartographicExerciseState extends State<CartographicExercise> {
  @override
  void initState() {
    if (this.mounted) {
      validateAdvise();
    }
    super.initState();
  }

  bool advise = false;
  @override
  Widget build(BuildContext context) {
    prov = Provider.of<ProviderInfo>(context);

    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return Scaffold(
      appBar: MainAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: queryData.size.height * 0.05,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: "LA UDEM YA NO CALLA",
                        style: TextStyle(
                          fontSize: 32,
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
                    text:
                        "Mira el mapa donde te hayas sentido insegurx o un lugar que crees inseguro",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DropdownButton<String>(
                  hint: Text("Selecciona un bloque"),
                  items: <String>[
                    'Bloque 1',
                    'Bloque 2',
                    'Bloque 3',
                    'Bloque 4',
                  ].map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value),
                    );
                  }).toList(),
                  value: valueChoosed,
                  onChanged: (newValue) {
                    setState(() {
                      valueChoosed = newValue;
                    });
                  },
                ),
                Theme(
                  data: Theme.of(context).copyWith(accentColor: Colors.white),
                  child: RaisedButton(
                    color: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    textColor: Colors.white,
                    onPressed: () {
                      if (valueChoosed == null) {
                        simpleAlert(context, "Aviso", "Selecciona un bloque");
                        return;
                      }
                      prov.setSelectedPlace(valueChoosed.toString());
                      
                      Navigator.of(context).pushNamed("/place_description");
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Continuar"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width,
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: ClipRect(
                      child: PhotoView(
                        imageProvider: AssetImage("assets/images/UdemMap.png"),
                        minScale: PhotoViewComputedScale.contained * 0.8,
                        maxScale: PhotoViewComputedScale.covered * 5,
                        initialScale: PhotoViewComputedScale.covered * 1,
                      ),
                    ),
                  )),
            ),
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "Mapa Universidad de Medellín",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontStyle: FontStyle.italic),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  void validateAdvise() {
    Future.delayed(Duration(milliseconds: 200), () async {
      if (!advise) {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => AlertDialog(
                  title:
                      Text("Te damos la bienvenida al ejercicio cartográfico"),
                  content: SingleChildScrollView(
                      child: Container(
                          child: Column(children: <Widget>[
                    RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                        text:
                            "Selecciona un lugar en el que te hayas sentido insegurx. \nPuedes hacer Zoom en el mapa",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Icon(Icons.zoom_in,
                    size: 60,
                    ),
                  ]))),
                  actions: [
                    FlatButton(
                      child: Text("Aceptar"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ));
        setState(() {
          advise = true;
        });
      }
    });
  }
}
