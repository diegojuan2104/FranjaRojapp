import 'package:flutter/material.dart';
import 'package:franja_rojapp/components/grid_menu.dart';
import 'package:franja_rojapp/components/main_appbar.dart';
import 'package:franja_rojapp/models/questionModel.dart';
import 'package:franja_rojapp/services/database.dart';

class Tendedero extends StatefulWidget {
  Tendedero({Key key}) : super(key: key);

  @override
  _TendederoState createState() => _TendederoState();
}

class _TendederoState extends State<Tendedero> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    return Container(
      child: Scaffold(
        appBar: MainAppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: queryData.size.height * 0.15,
              ),
              Container(
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: "Tendedero",
                        style: TextStyle(
                          fontSize: 45,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'BigShouldersDisplay',
                        ),
                      ),
                    )),
              ),
              Container(
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: "¿Qué putas Estás Callando?",
                        style: TextStyle(
                          fontSize: 45,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'DancingScript',
                        ),
                      ),
                    )),
              ),
              Container(
                padding: EdgeInsets.all(15),
                child: GridView.count(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  children: <Widget>[
                    GridMenu(
                      title: "Ejercicio Cartográfico",
                      icon: Icons.map,
                      warna: Colors.red,
                      action: () {
                        //AddQuestionsAgain();
                        Navigator.of(context)
                            .pushNamed("/cartographic_exercise");
                      },
                    ),
                    GridMenu(
                      title: "Historias",
                      icon: Icons.library_books,
                      warna: Colors.red,
                      action: () {
                        Navigator.of(context).pushNamed("/stories");
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

//   AddQuestionsAgain() async {
//     List sino = ["Sí", "No"];

//     List sinonose = ["Sí", "No", "No sé"];

//     List sinona = ["Sí", "No", "No aplica"];

//     List<QuestionModel> questions = [
//       QuestionModel(
//         answers: sino,
//         question:
//             "¿Conoces la Política de Inclusión y de Reconocimiento de la Diversidad en la Universidad de Medellín?",
//       ),
//       QuestionModel(
//           openQuestion: true,
//           question: "¿Cúal es tu edad?",
//           intInputType: true),
//       QuestionModel(
//         answers: [
//           "Administrativo",
//           "Docente",
//           "Estudiante",
//           "Egresado",
//           "Otro"
//         ],
//         question: "¿A qué estamento de la comunidad universitaria perteneces?",
//       ),
//       QuestionModel(
//         answers: sinonose,
//         question:
//             "¿Has sido víctima de violencias basadas en género en la Universidad?",
//       ),
//       QuestionModel(
//         index: 5,
//         answers: sinonose,
//         question:
//             "¿Te consideras en la capacidad de reconocer situaciones de violencia basadas en género en el contexto universitario?",
//       ),
//       QuestionModel(
//         answers: [
//           "Femenino",
//           "Masculino",
//           "Intersexual",
//           "Prefiero no decirlo",
//           "No me identifico con ninguno"
//         ],
//         question: "¿Con cual sexo te identificas?",
//       ),
//       QuestionModel(
//         answers: sino,
//         question:
//             "¿Has sufrido persecución o arrinconamientos de tipo sexual, sin consentimiento, en las instalaciones de la Universidad?",
//       ),
//       QuestionModel(
//         answers: sinonose,
//         question:
//             "¿Consideras que existe la necesidad de tener una ruta para la atención de las violencias basadas en género al interior de la Universidad?",
//       ),
//       QuestionModel(
//         answers: sinonose,
//         question:
//             "¿Has recibido comentarios inapropiados sobre tu cuerpo dentro de la Universidad?",
//       ),
//       QuestionModel(
//         openQuestion: true,
//         question:
//             "¿En qué parte de la universidad no te quedarías solo/a/e? Escribe los lugares.",
//       ),
//       QuestionModel(
//         openQuestion: true,
//         question:
//             "¿Cuál consideras que es el sitio más peligroso de la Universidad y sus alrededores para las mujeres y para las personas con identidades de género y orientaciones sexuales diversas? Enumera si tienes más de uno.",
//       ),
//       QuestionModel(
//         openQuestion: true,
//         question:
//             "¿Cuál consideras que es el sitio más peligroso de la Universidad y sus alrededores para las mujeres y para las personas con identidades de género y orientaciones sexuales diversas? Enumera si tienes más de uno.",
//       ),
//       QuestionModel(
//         openQuestion: true,
//         question:
//             "¿Cuál consideras que es el sitio más peligroso de la Universidad y sus alrededores para las mujeres y para las personas con identidades de género y orientaciones sexuales diversas? Enumera si tienes más de uno.",
//       ),
//       QuestionModel(
//         answers: sinonose,
//         question:
//             "¿En casos de violencia y discriminación por razones de género, consideras que la Universidad cuenta con los canales adecuados para el tratamiento de esas situaciones?",
//       ),
//       QuestionModel(
//         answers: sinona,
//         question:
//             "¿En casos de violencia y discriminación por razones de género, consideras que la Universidad cuenta con los canales adecuados para el tratamiento de esas situaciones?",
//       ),
//       QuestionModel(
//         answers: sino,
//         question:
//             "¿Has recibido tocamientos indeseados de carácter sexual en el entorno universitario?",
//       ),
//       QuestionModel(
//         answers: sinonose,
//         question:
//             "¿Alguna persona de la comunidad universitaria (docentes, estudiantes, administrativo/a etc.) te ha hecho preguntas o insinuaciones sobre tu vida sexual?",
//       ),
//       QuestionModel(
//         openQuestion: true,
//         question:
//             "¿Cuáles consideras tú, son las personas o grupos más discriminados por razones de género?",
//       ),
//       QuestionModel(
//         answers: sino,
//         question:
//             "¿Consideras que las personas enfrentan mayores desafíos o prejuicios dependiendo de su origen étnico, condición socio-económica, religión, orientación sexual e identidad de género?",
//       ),
//       QuestionModel(
//         answers: sino,
//         question:
//             "¿Alguna vez en el aula de clases te han censurado por usar el lenguaje inclusivo o no sexista?",
//       ),
//       QuestionModel(
//         answers: sino,
//         question: "¿En algún momento has dudado sobre tu sexualidad?",
//       ),
//       QuestionModel(
//         answers: sino,
//         question: "¿En algún momento has dudado sobre tu identidad de género?",
//       ),
//       QuestionModel(
//         answers: sino,
//         question:
//             "¿Alguna vez has sentido que quien eres está por fuera de todas las normas socialmente impuestas para el sexo y el género?",
//       ),
//       QuestionModel(
//         answers: sino,
//         question:
//             "¿Sientes o consideras que en la Universidad la oferta educativa está orientada a reproducir los roles tradicionalmente impuestos con respecto al sexo y al género?",
//       ),
//       QuestionModel(
//         answers: sino,
//         question: "¿Consideras que los piropos son acoso?",
//       ),
//       QuestionModel(
//         answers: sino,
//         question:
//             "¿Alguna vez han neutralizado tu cuerpo, esto es, que las personas han pretendido decirte cómo debe ser y a quien pertenece?",
//       ),
//       QuestionModel(
//         answers: sino,
//         question:
//             "¿Alguna vez te han dicho que entre menos expreses tu punto de vista eres mejor?",
//       ),
//       QuestionModel(
//         answers: sino,
//         question:
//             "¿Crees que en la universidad existe un lenguaje autorizado y uno no autorizado?",
//       ),
//       QuestionModel(
//         answers: sino,
//         question: "¿Has recibido más normas y menos espacios?",
//       ),
//       QuestionModel(
//         answers: sino,
//         question:
//             "¿Te han dicho exagerada/o/e por denunciar casos de violencia?",
//       ),
//     ];

//     for (int i = 0; i < questions.length; i++) {
//       questions[i].setIndex(i);
//       await DatabaseService().createAQuestion(questions[i]);
//     }
//   }
}
