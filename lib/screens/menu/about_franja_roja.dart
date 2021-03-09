import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutFranjaRoja extends StatelessWidget {
  const AboutFranjaRoja({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final queryData = MediaQuery.of(context);
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: queryData.size.height * 0.15,
        ),
        Padding(
            padding: const EdgeInsets.all(10.0),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: "Franja Roja",
                style: TextStyle(
                  fontSize: 80,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Silvertone',
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
          padding: const EdgeInsets.all(10.0),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text:
                  '''¡Nuestro proyecto se enmarca como un precedente en los procesos de atención a las Violencias Basadas en Género de la Universidad de Medellín!\n 
Está direccionado a construir un diagnóstico que será base para la creación de una propuesta de Política, Protocolo y Ruta de atención a las violencias basadas en género\n
\n Esta aplicación se construyó con la finalidad reunir y medir información acerca de las violencias basadas en género en el contexto de la Universidad de Medellín.                  
                  
                  \n¡Por una UdeM sin VIOLENCIAS!
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
          onPressed: ()async  {
            const url = "https://www.instagram.com/franja.roja/?hl=es-la";
            if(await canLaunch(url)){
              await launch(url);
            }else{
              throw "Could not launch $url";
            }
          },
        ),
      ],
    ));
  }

  Future _launchURL() async =>
    await canLaunch("https://www.instagram.com/franja.roja/?hl=es-la") ? await launch("https://www.instagram.com/franja.roja/?hl=es-la") : throw 'Could not launch URL';
}
