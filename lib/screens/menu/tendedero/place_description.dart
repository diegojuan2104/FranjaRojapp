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
  @override
  Widget build(BuildContext context) {
    prov = Provider.of<ProviderInfo>(context);
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return Container(
        child: Scaffold(
      appBar: MainAppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(10.0),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "LUGAR SELECCIONADO: " + prov.placeSelected,
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'BigShouldersDisplay',
                  ),
                ),
              )),
          SizedBox(
            height: 20,
          ),
          Container(
            width: queryData.size.width * 0.8,
            child: TextField(
              controller: desriptionController,
              maxLines: 2,
              decoration: InputDecoration(
                  hintText: "Descripción",
                  border: OutlineInputBorder(),
                  labelText: 'Describe el lugar más específicamente'),
            ),
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
                onPressed: () {},
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
    ));
  }
}
