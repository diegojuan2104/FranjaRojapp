import 'package:flutter/material.dart';
import 'package:franja_rojapp/components/main_appbar.dart';
import 'package:franja_rojapp/providers/Providerinfo.dart';
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
    super.initState();
  }

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
                      prov..setSelectedPlace(valueChoosed.toString());
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
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.redAccent,
                  width: 2
                  ),
                  
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage("assets/images/UdemMap.png"),
                  ),
                ),
              ),
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

  void showDescribreThePlace() {}
}
