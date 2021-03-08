import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:franja_rojapp/components/grid_avatar.dart';
import 'package:franja_rojapp/models/avatar_grid_part.dart';
import 'package:franja_rojapp/models/questionModel.dart';
import 'package:franja_rojapp/services/auth.dart';
import 'dart:math';

import 'package:franja_rojapp/services/database.dart';

const IMAGES_WORD = '-removebg-preview';


simpleAlert(context, title, text) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(child: Container(child: Text(text))),
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

const String TERMINOS_Y_CONDICIONES =
    ("""FRANJAROJAPP garantiza la protección de los datos proporcionados por las personas usuarias. Todo estos son tratados con absoluta confidencialidad, siendo usados exclusivamente con los fines por los que han sido solicitados, en cumplimiento de las disposiciones de la Ley 1582 de 2012, Decreto 1377 de 2013, y demás normas vigentes y complementarias. \n
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

moreQuestions(context, franjas) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              "Felicidades!",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
                child: Container(
                    child: Text("Has ganado " +
                        franjas.toString() +
                        " franjas para modificar tu ávatar, aún puedes ganar muchas más!  ¿Deseas continuar respondiendo preguntas?"))),
            actions: [
              FlatButton(
                child: Text("Si!"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacementNamed(context, "/question");
                },
              ),
              FlatButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ));
}

_createQuestion() async {
  String question =
      "¿Conoces la Política de Inclusión y de Reconocimiento de la Diversidad en la Universidad de Medellín?";
  List sino = ["Si", "No"];

  List sinonose = ["Si", "No", "No sé"];

  List sinona = ["Si", "No", "No aplica"];

  List<QuestionModel> questions = [
    QuestionModel(
      answers: sino,
      question:
          "¿Conoces la Política de Inclusión y de Reconocimiento de la Diversidad en la Universidad de Medellín?",
    ),
    QuestionModel(
        openQuestion: true, question: "¿Cúal es tu edad?", intInputType: true),
    QuestionModel(
      answers: ["Administrativo", "Docente", "Estudiante", "Egresado", "Otro"],
      question: "¿A qué estamento de la comunidad universitaria perteneces?",
    ),
    QuestionModel(
      answers: sinonose,
      question:
          "¿Has sido víctima de violencias basadas en género en la Universidad?",
    ),
    QuestionModel(
      answers: sinonose,
      question:
          "¿Te consideras en la capacidad de reconocer situaciones de violencia basadas en género en el contexto universitario?",
    ),
    QuestionModel(
      answers: [
        "Femenino",
        "Masculino",
        "Intersexual",
        "Prefiero no decirlo",
        "No me identifico con ninguno"
      ],
      question: "¿Con cual sexo te identificas?",
    ),
    QuestionModel(
      answers: sino,
      question:
          "¿Has sufrido persecución o arrinconamientos de tipo sexual, sin consentimiento, en las instalaciones de la Universidad?",
    ),
    QuestionModel(
      answers: sinonose,
      question:
          "¿Consideras que existe la necesidad de tener una ruta para la atención de las violencias basadas en género al interior de la Universidad?",
    ),
    QuestionModel(
      answers: sinonose,
      question:
          "¿Has recibido comentarios inapropiados sobre tu cuerpo dentro de la Universidad?",
    ),
    QuestionModel(
      openQuestion: true,
      question:
          "¿En qué parte de la universidad no te quedarías solo/a/e? Escribe los lugares.",
    ),
    QuestionModel(
      openQuestion: true,
      question:
          "¿Cuál consideras que es el sitio más peligroso de la Universidad y sus alrededores para las mujeres y para las personas con identidades de género y orientaciones sexuales diversas? Enumera si tienes más de uno.",
    ),
    QuestionModel(
      openQuestion: true,
      question:
          "¿Cuál consideras que es el sitio más peligroso de la Universidad y sus alrededores para las mujeres y para las personas con identidades de género y orientaciones sexuales diversas? Enumera si tienes más de uno.",
    ),
    QuestionModel(
      openQuestion: true,
      question:
          "¿Cuál consideras que es el sitio más peligroso de la Universidad y sus alrededores para las mujeres y para las personas con identidades de género y orientaciones sexuales diversas? Enumera si tienes más de uno.",
    ),
    QuestionModel(
      answers: sinonose,
      question:
          "¿En casos de violencia y discriminación por razones de género, consideras que la Universidad cuenta con los canales adecuados para el tratamiento de esas situaciones?",
    ),
    QuestionModel(
      answers: sinona,
      question:
          "¿En casos de violencia y discriminación por razones de género, consideras que la Universidad cuenta con los canales adecuados para el tratamiento de esas situaciones?",
    ),
    QuestionModel(
      answers: sino,
      question:
          "¿Has recibido tocamientos indeseados de carácter sexual en el entorno universitario?",
    ),
    QuestionModel(
      answers: sinonose,
      question:
          "¿Alguna persona de la comunidad universitaria (docentes, estudiantes, administrativo/a etc.) te ha hecho preguntas o insinuaciones sobre tu vida sexual?",
    ),
    QuestionModel(
      openQuestion: true,
      question:
          "¿Cuáles consideras tú, son las personas o grupos más discriminados por razones de género?",
    ),
    QuestionModel(
      answers: sino,
      question:
          "¿Consideras que las personas enfrentan mayores desafíos o prejuicios dependiendo de su origen étnico, condición socio-económica, religión, orientación sexual e identidad de género?",
    ),
    QuestionModel(
      answers: sino,
      question:
          "¿Alguna vez en el aula de clases te han censurado por usar el lenguaje inclusivo o no sexista?",
    ),
    QuestionModel(
      answers: sino,
      question: "¿En algún momento has dudado sobre tu sexualidad?",
    ),
    QuestionModel(
      answers: sino,
      question: "¿En algún momento has dudado sobre tu identidad de género?",
    ),
    QuestionModel(
      answers: sino,
      question:
          "¿Alguna vez has sentido que quien eres está por fuera de todas las normas socialmente impuestas para el sexo y el género?",
    ),
    QuestionModel(
      answers: sino,
      question:
          "¿Sientes o consideras que en la Universidad la oferta educativa está orientada a reproducir los roles tradicionalmente impuestos con respecto al sexo y al género?",
    ),
    QuestionModel(
      answers: sino,
      question: "¿Consideras que los piropos son acoso?",
    ),
    QuestionModel(
      answers: sino,
      question:
          "¿Alguna vez han neutralizado tu cuerpo, esto es, que las personas han pretendido decirte cómo debe ser y a quien pertenece?",
    ),
    QuestionModel(
      answers: sino,
      question:
          "¿Alguna vez te han dicho que entre menos expreses tu punto de vista eres mejor?",
    ),
    QuestionModel(
      answers: sino,
      question:
          "¿Crees que en la universidad existe un lenguaje autorizado y uno no autorizado?",
    ),
    QuestionModel(
      answers: sino,
      question: "¿Has recibido más normas y menos espacios?",
    ),
    QuestionModel(
      answers: sino,
      question: "¿Te han dicho exagerada/o/e por denunciar casos de violencia?",
    ),
  ];

  questions.forEach((element) async {
    await DatabaseService().createAQuestion(element);
  });
  //DatabaseService().generateRandomQuestion();
}
class Constants {
  static double TAB_BAR_SIZE = 0.131;
  static double SPACING_BAR_SIZE = 0.101;
  static String HOME_SCREEN = 'HOME_SCREEN';

  static List<Color> initializMapColors() {
    final lista = [
      Colors.red[900],
      Colors.orange,
      Colors.blue,
      Colors.green,
      Colors.pink,
      Colors.purple,
      Colors.lime,
      Colors.cyan
    ];

    return lista;
  }

  static Map<String, List<double>> getMesureMap() {
    final dict = {
      "ojos": [175.0, 150.0],
      "boca": [125.0, 100.0],
      "nariz": [80.0, 80.0],
      "orejas": [250.0, 140.0],
      "mascotas": [100.0, 100.0],
      "figuras": [100.0, 100.0],
      "plantas": [100.0, 100.0],
      "cuerpo": [100.0, 100.0],
    };
    return dict;
  }

  static Map<String, List<AvatarModel>> initializMap() {
    final dict = {
      "ojos": fillList(getImgPaths('ojos', 'ojosapp', 42)),
      "boca": fillList(getImgPaths('boca', 'bocasapp', 31)),
      "nariz": fillList(getImgPaths('nariz', 'naricesapp', 18)),
      "orejas": fillList(getImgPaths('oreja', 'orejasapp', 8)),
      "mascotas": fillList(getImgPaths('pet', 'petsapp', 20)),
      "figuras": fillList(getImgPaths('fig', 'figapp', 6)),
      "cuerpo": fillList(getImgPaths('bodypart', 'partescuerpoapp', 12)),
      "plantas": fillList(getImgPaths('planta', 'plantasapp', 17)),
    };
    dict["ojos"][0].numFranjas = 10;
    return dict;
  }

  static List<AvatarModel> fillList(List<String> lista) {
    List<AvatarModel> ret = [];
    bool flag = true;
    print(lista.length);
    print((lista.length / 2).round());
    for (int i = 0; i < lista.length; i += 2) {
      if (flag) {
        ret.add(createAv(lista[i], Colors.red[50]));
        if (i + 1 < lista.length)
          ret.add(createAv(lista[i + 1], Colors.white));
        flag = false;
      } else {
        ret.add(createAv(lista[i], Colors.white));
        if (i + 1 < lista.length)
          ret.add(createAv(lista[i + 1], Colors.red[50]));
        flag = true;
      }
    }

    return ret;
  }

  static AvatarModel createAv(String s, Color c) {
    return AvatarModel(image: s, color: c);
  }

  static List<String> getImgPaths(String pal, String dir, int numImg) {
    List<String> ret = [];
    for (var i = 1; i <= numImg; i++) {
      ret.add('assets/imagesapp/$dir/$pal$i$IMAGES_WORD.png');
    }
    return ret;
  }

  static createListTabs(List<String> parameters, ScrollController s) {
    List<Widget> tabsW = [];
    for (int i = 0; i < parameters.length; i++) {
      tabsW.add(TabWidget(
        parameter: parameters[i],
        scrollController: s,
      ));
    }
    return tabsW;
  }

  static createListWTabs(List<String> names) {
    List<Tab> tabs = [];
    for (int i = 0; i < names.length; i++) {
      tabs.add(Tab(
        child: Text(names[i]),
      ));
    }
    return tabs;
  }
}
