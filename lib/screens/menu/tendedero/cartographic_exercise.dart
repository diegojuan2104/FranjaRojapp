import 'package:flutter/material.dart';
import 'package:franja_rojapp/components/main_appbar.dart';
import 'package:franja_rojapp/providers/Providerinfo.dart';
import 'package:provider/provider.dart';
import 'package:photo_view/photo_view.dart';

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    prov = Provider.of<ProviderInfo>(context);
    return Scaffold(
      appBar: MainAppBar(),
      body: SingleChildScrollView(
        child: !valueChoosedAndAcepted
            ? Column(
                children: <Widget>[
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
                          text:
                              "Mira el mapa y selecciona un lugar que crees inseguro o donde te hayas sentido insegurx",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        data: Theme.of(context)
                            .copyWith(accentColor: Colors.white),
                        child: RaisedButton(
                          color: Theme.of(context).primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          textColor: Colors.white,
                          onPressed: () {
                            prov..setSelectedPlace(valueChoosed.toString());
                            Navigator.of(context)
                                .pushNamed("/place_description");
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
                              imageProvider:
                                  AssetImage("assets/images/UdemMap.png"),
                              minScale: PhotoViewComputedScale.contained * 0.8,
                              maxScale: PhotoViewComputedScale.covered * 5,
                              initialScale:  PhotoViewComputedScale.covered *1,
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
              )
            : Column(),
      ),
    );
  }

  void showDescribreThePlace() {}
}
