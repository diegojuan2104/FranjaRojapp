import 'package:flutter/material.dart';
import 'package:franja_rojapp/components/grid_menu.dart';
import 'package:franja_rojapp/components/loading.dart';
import 'package:franja_rojapp/constants/constants.dart';
import 'package:franja_rojapp/components/main_appbar.dart';
import 'package:franja_rojapp/models/QuestionModel.dart';
import 'package:franja_rojapp/providers/data.dart';
import 'package:franja_rojapp/screens/menu/avatar.dart';
import 'package:franja_rojapp/services/auth.dart';
import 'package:franja_rojapp/services/database.dart';
import 'package:provider/provider.dart';

import '../../providers/Providerinfo.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ProviderInfo prov;

  bool _loading = false;
  int franjas = 0;
  bool firstReward;
  bool avatarIsCreated;
  Data prov2;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    prov = Provider.of<ProviderInfo>(context);
    final provD = Provider.of<Data>(context);
    prov2 = Provider.of<Data>(context);

    setCurrentProfileData();
    validateFirstReward();
    return _loading || prov.currentProfile == null
        ? Loading()
        : prov.currentProfile.avatar_created
            ? Scaffold(
                backgroundColor: Colors.white,
                appBar: MainAppBar(),
                body: SingleChildScrollView(
                  child: Column(children: [
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: provD.imgAv != null
                          ? Image.memory(
                              provD.imgAv,
                              width: 150,
                              height: 150,
                              fit: BoxFit.fill,
                            )
                          : Text(""),
                    ),
                    Container(
                      padding: EdgeInsets.all(15),
                      child: GridView.count(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        children: <Widget>[
                          GridMenu(
                            title: "Mi avatar",
                            icon: Icons.person,
                            warna: Colors.red,
                            action: _showAvatar,
                          ),
                          GridMenu(
                              title: "Tendedero",
                              icon: Icons.flag,
                              warna: Colors.red,
                              action: () => {_createQuestion()}),
                          GridMenu(
                              title: "Glosario Rojo",
                              icon: Icons.book,
                              warna: Colors.red,
                              action: () =>
                                  {Navigator.pushNamed(context, "/glossary")}),
                          GridMenu(
                              title: "Gana Franjas!",
                              icon: Icons.line_weight,
                              warna: Colors.red,
                              action: () =>
                                  {Navigator.pushNamed(context, "/question")}),
                          GridMenu(
                              title: "Sobre Franja Roja",
                              icon: Icons.info_outline,
                              warna: Colors.red,
                              action: () =>
                                  {Navigator.pushNamed(context, "/about")}),
                          GridMenu(
                              title: "Cerrar Sesión",
                              icon: Icons.arrow_back,
                              warna: Colors.grey,
                              action: _signOut),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "FranjaRojApp Versión " + VERSION,
                      style: TextStyle(color: Colors.black54),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ]),
                ))
            : AvatarPage();
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
          openQuestion: true,
          question: "¿Cúal es tu edad?",
          intInputType: true),
      QuestionModel(
        answers: [
          "Administrativo",
          "Docente",
          "Estudiante",
          "Egresado",
          "Otro"
        ],
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
        question:
            "¿Te han dicho exagerada/o/e por denunciar casos de violencia?",
      ),
    ];

    for (var i = questions.length - 1; i >= 0; i--) {
      print(questions[i].question);
    }
  }

  setCurrentProfileData() {
    DatabaseService().getCurrentProfile().then(
        (value) => {prov.setCurrentProfile(value), prov2.currentProf = value});
  }

  _signOut() async {
    try {
      setState(() {
        _loading = true;
      });
      await Auth().signOutUser();
      Navigator.of(context).pushReplacementNamed(
        '/auth',
      );
      setState(() {
        _loading = false;
      });
    } catch (e) {
      simpleAlert(context, "Aviso", "Ha ocurrido un error");
    }
  }

  _showAvatar() {
    Navigator.of(context).pushNamed(
      '/avatar',
    );
  }

  void validateFirstReward() {
    Future.delayed(Duration(milliseconds: 2000), () async {
      if (prov.currentProfile != null) {
        if (!prov.currentProfile.first_reward) {
          DatabaseService()
              .addFranjas(context, prov.currentProfile.franjas, 10);
          DatabaseService().saveFirstReward(true);
          simpleAlert(
              context, "Felicidades", "Has ganado 10 franjas por registrarte!");
        }
      }
    });
  }
}
