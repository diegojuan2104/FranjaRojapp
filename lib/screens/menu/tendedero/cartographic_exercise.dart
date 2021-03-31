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

List<String> items = [
  'Bloque 1',
  'Bloque 2',
  'Bloque 3',
  'Bloque 4',
  'Bloque 5',
  'Bloque 6',
  'Bloque 7',
  'Bloque 8',
  'Bloque 9',
  'Bloque 10',
  'Bloque 11',
  'Bloque 12',
  'Bloque 13',
  'Bloque 14',
  'Bloque 15',
  'Bloque 16',
  'Bloque 17',
  'Bloque 18',
  'Bloque 19',
  'Bloque 20',
  'Bloque 21'
];

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
                        text: "Ejercicio Cartográfico",
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
            Container(
              child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "La udem ya no calla",
                      style: TextStyle(
                        fontSize: 45,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'DancingScript',
                      ),
                    ),
                  )),
            ),
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    text:
                        "Observa detenidamente el mapa y luego selecciona un lugar de la Universidad en donde te hayas sentido insegerx por razones de género. En caso de que tu lugar no sea propiamente un bloque, selecciona el más cercano, ya que posteriormente podrás explicarnos más a fondo donde se sitúa.",
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
                  items: items.map((String value) {
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
                            "Te invitamos a seleccionar un lugar de la Universidad en donde te hayas sentido insegerx por razones de género. En caso de que tu lugar no sea propiamente un bloque, selecciona el más cercano, ya que posteriormente podrás explicarnos más a fondo donde se sitúa. \nRecuerda que puedes hacer zoom en el mapa.",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Icon(
                      Icons.zoom_in,
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
