import 'package:flutter/material.dart';
import 'package:franja_rojapp/components/main_appbar.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutFranjaRoja extends StatelessWidget {
  const AboutFranjaRoja({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final queryData = MediaQuery.of(context);
    return Scaffold(
        appBar: MainAppBar(),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: queryData.size.height * 0.05,
              ),
              Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "Franja Roja",
                      style: TextStyle(
                        fontSize: 55,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'DancingScript',
                      ),
                    ),
                  )),
              // FractionallySizedBox(
              //   widthFactor: .7,
              //   child: ClipRRect(
              //     borderRadius: BorderRadius.circular(8.0),
              //     child: Image.asset(
              //       "assets/images/FranjaRojapp_logo_blanco.png",
              //     ),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    text:
                        '''Una propuesta para mitigar la violencia basada en género en el contexto de la Universidad de Medellín, es un proyecto que le apuesta a articular acciones orientadas a la formación, análisis, visibilización y socialización de las violencias basadas en género en el contexto universitario. Este proyecto surge debido a la deficiencia de las rutas, versiones y/o borradores de rutas y protocolos de atención a las violencias basadas en género en la Universidad de Medellín. Pretende ser un proceso pedagógico en el que se propicie la comprensión por parte de la comunidad universitaria de todo aquello que compone, determina y acarrea las violencias basadas en género dentro y fuera del entorno universitario.''',
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'BigShouldersDisplay',
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: '''
                    \n CONTACTO:
                    \nfranja.roja2020@gmail.com
                    \n Redes Sociales:
                    ''',
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'BigShouldersDisplay',
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              IconButton(
                icon: Image.asset('assets/images/instagram.png'),
                iconSize: 50,
                onPressed: () async {
                  const url = "https://www.instagram.com/franja.roja/?hl=es-la";
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw "Could not launch $url";
                  }
                },
              ),
            ],
          ),
        ));
  }

  Future _launchURL() async =>
      await canLaunch("https://www.instagram.com/franja.roja/?hl=es-la")
          ? await launch("https://www.instagram.com/franja.roja/?hl=es-la")
          : throw 'Could not launch URL';
}
