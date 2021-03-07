import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:franja_rojapp/services/auth.dart';
import 'dart:math';

simpleAlert(context, title, text){
   showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(title),
              content: SingleChildScrollView(
                  child: Container(
                      child: Text(text))),
              actions: [
                FlatButton(
                  child: Text("Aceptar"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
}
const String TERMINOS_Y_CONDICIONES = ("""FRANJAROJAPP garantiza la protección de los datos proporcionados por las personas usuarias. Todo estos son tratados con absoluta confidencialidad, siendo usados exclusivamente con los fines por los que han sido solicitados, en cumplimiento de las disposiciones de la Ley 1582 de 2012, Decreto 1377 de 2013, y demás normas vigentes y complementarias. \n
ACEPTACIÓN DE LAS CONDICIONES DE USO. El acceso y utilización de la aplicación supone que las personas usuarias están aceptando en su totalidad las condiciones y, por esta aceptación, se obligan a cumplir los TÉRMINOS Y CONDICIONES de la aplicación. Por lo tanto, las personas usuarias deberán leer detenidamente las presentes CONDICIONES DE USO, así como los otros TÉRMINOS Y CONDICIONES aquí consignados.\n
Es importante que las personas usuarias sepan que, al diligenciar el presente formulario de ingreso, estarán aceptando los términos propuestos y que estarán de acuerdo con que sus datos personales sean almacenados en nuestras bases de datos para ser utilizados con fines informativos y divulgativos, conservando el anonimato de quienes los proporcionaron. \n
FRANJAROJAPP se reserva el derecho de actualizar, modificar o eliminar los presentes términos y condiciones. Si esto sucede, oportunamente se notificará a las personas usuarias de la aplicación para que acepten nuevamente, y en su totalidad los términos y condiciones. \n
CONDICIONES DE USO DE LA APLICACIÓN. Desde un principio es necesario aclarar que esta aplicación es para el uso exclusivo de la comunidad Universidad de Medellín.\n
Las personas usuarias se obligan a darle buen uso de la aplicación FRANJAROJAPP, esto de acuerdo a los establecido en la legislación vigente, el orden público y la buena fe. Así mismo, las personas usuarias se comprometen a no utilizar la aplicación FRANJAROJAPP con fines fraudulentos y contrarios a sus propósitos fundamentales. Las personas usuarias también se comprometen a no realizar ninguna conducta que pueda afectar la imagen, los intereses y los derechos de imagen, explotación y fundamentales la aplicación FRANJAROJAPP; esto incluye a otras personas usuarias y a terceros.\n
Las personas usuarias se comprometen a no realizar acto alguno que dañe, afecte o inhabilite el buen funcionamiento de la aplicación FRANJAROJAPP. \n
PROPIEDAD INTELECTUAL. Todo el material informático, material gráfico, material fotográfico, multimedia y de diseño, así como todos los contenidos (por ejemplo, textos, bases de datos puestos a su disposición en esta aplicación, entre otros), están protegidos por los derechos que protegen la propiedad intelectual y los derechos de autor regulados en el artículo 671 de Código Civil Colombiano, la Ley 23 de 1982, la Ley 44 de 1993 y demás normas vigentes y complementarias.\n
SEGURIDAD. La aplicación FRANJAROJAPP está comprometida con la íntegra protección de la seguridad de los datos proporcionados por todas las personas usuarias. Contamos con mecanismo de seguridad que garantizan la protección de la información personal. Asimismo, se garantiza que el acceso a estos datos corresponde, únicamente, al personal y sistemas autorizados.\n
""");

const String VERSION = "1.0.0";

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}



List shuffle(List items) {
  var random = new Random();

  // Go through all elements.
  for (var i = items.length - 1; i > 0; i--) {

    // Pick a pseudorandom number according to the list length
    var n = random.nextInt(i + 1);

    var temp = items[i];
    items[i] = items[n];
    items[n] = temp;
  }

  return items;
}


