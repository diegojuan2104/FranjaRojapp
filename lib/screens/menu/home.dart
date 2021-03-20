import 'package:flutter/material.dart';
import 'package:franja_rojapp/components/grid_menu.dart';
import 'package:franja_rojapp/components/loading.dart';
import 'package:franja_rojapp/constants/constants.dart';
import 'package:franja_rojapp/components/main_appbar.dart';
import 'package:franja_rojapp/providers/data.dart';
import 'package:franja_rojapp/screens/menu/avatar.dart';
import 'package:franja_rojapp/screens/menu/glossary.dart';
import 'package:franja_rojapp/screens/menu/tendedero/cartographic_exercise.dart';
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
    if (this.mounted) {
      validateNewUser();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    prov = Provider.of<ProviderInfo>(context);
    final provD = Provider.of<Data>(context);
    prov2 = Provider.of<Data>(context);
    setCurrentProfileData();

    return _loading || prov.currentProfile == null
        ? Loading()
        : prov.currentProfile.avatar_created
            ? (prov.currentProfile.glossary_opened
                ? (prov.currentProfile.tendedero_opened
                    ? Scaffold(
                        backgroundColor: Colors.grey[50],
                        appBar: MainAppBar(),
                        body: SingleChildScrollView(
                          child: Column(children: [
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.red, // set border color
                                    width: 0.5),
                                borderRadius: BorderRadius.all(Radius.circular(
                                    5)), // set rounded corner radius// make rounded corner of border
                              ),
                              // set bo ,
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
                                      action: () => {
                                            Navigator.pushNamed(
                                                context, "/tendedero")
                                          }),
                                  GridMenu(
                                      title: "Glosario Rojo",
                                      icon: Icons.book,
                                      warna: Colors.red,
                                      action: () => {
                                            Navigator.pushNamed(
                                                context, "/glossary")
                                          }),
                                  GridMenu(
                                      title: "Gana Franjitas!",
                                      icon: Icons.line_weight,
                                      warna: Colors.red,
                                      action: () => {
                                            Navigator.pushNamed(
                                                context, "/question")
                                          }),
                                  GridMenu(
                                      title: "Sobre Franja Roja",
                                      icon: Icons.info_outline,
                                      warna: Colors.red,
                                      action: () => {
                                            Navigator.pushNamed(
                                                context, "/about")
                                          }),
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
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontStyle: FontStyle.italic),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ]),
                        ))
                    : CartographicExercise())
                : Glossary())
            : AvatarPage();
  }

  _createQuestion() async {
    for (var i = 0; i < questions.length; i++) {
      questions[i].setIndex(i + 1);
      await DatabaseService().createAQuestion(questions[i]);
    }
  }

  setCurrentProfileData() {
    DatabaseService().getCurrentProfile().then(
        (value) => {prov.setCurrentProfile(value), prov2.currentProf = value});
  }

  validateNewUser() {
    Future.delayed(Duration(milliseconds: 200), () async {
      if (prov == null) return;
      if (prov.currentProfile == null) return;
      if (prov.currentProfile.avatar_created == false) return;
      if (prov.currentProfile.glossary_opened == false) return;
      if (prov.currentProfile.isNewUser) {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => AlertDialog(
                  title:
                      Text("Te damos la bienvenida al panel de FranjaRojApp"),
                  content: SingleChildScrollView(
                      child: Container(
                    child: Column(
                      children: <Widget>[
                        RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                            text:
                                '''Puedes volver a acceder cuando desees a las diferentes carácteristicas del app ya sea volver a editar tu ávatar, ver el glosario o enviarnos una historia''',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
                  actions: [
                    FlatButton(
                      child: Text("Aceptar"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ));
        DatabaseService().saveIsNewUser(false);
      }
    });
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
    Navigator.of(context).pushReplacementNamed(
      '/avatar',
    );
  }
}
