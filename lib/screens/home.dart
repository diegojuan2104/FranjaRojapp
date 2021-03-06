import 'package:flutter/material.dart';
import 'package:franja_rojapp/components/grid_menu.dart';
import 'package:franja_rojapp/components/loading.dart';
import 'package:franja_rojapp/constants/constants.dart';
import 'package:franja_rojapp/providers/ProviderInfo.dart';
import 'package:franja_rojapp/components/main_appbar.dart';
import 'package:franja_rojapp/services/auth.dart';
import 'package:franja_rojapp/services/database.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    prov = Provider.of<ProviderInfo>(context);
    setCurrentProfileData();

    return _loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.grey[150],
            appBar: MainAppBar(),
            body: SingleChildScrollView(
              child: Column(children: [
                SizedBox(
                  height: 20,
                ),
                CircleAvatar(
                  radius: 60.0,
                  backgroundImage: NetworkImage(
                      'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png'),
                  backgroundColor: Colors.transparent,
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
                          action: null),
                      GridMenu(
                          title: "Glosario Rojo",
                          icon: Icons.book,
                          warna: Colors.red,
                          action: null),
                      GridMenu(
                          title: "Preguntas",
                          icon: Icons.line_weight,
                          warna: Colors.red,
                          action: () =>
                              {Navigator.pushNamed(context, "/question")}),
                      GridMenu(
                          title: "Sobre Franja Roja",
                          icon: Icons.info_outline,
                          warna: Colors.red,
                          action: null),
                      GridMenu(
                          title: "Cerrar Sesión",
                          icon: Icons.arrow_back,
                          warna: Colors.grey,
                          action: _signOut),
                    ],
                  ),
                ),
                Text(
                  "FranjaRojApp Versión 1.0.0",
                  style: TextStyle(color: Colors.black54),
                ),
                SizedBox(
                  height: 20,
                ),
              ]),
            ));
  }

  setCurrentProfileData() {
    DatabaseService().getCurrentProfile().then((value) => {
      prov.setCurrentProfile(value)
      });
  }

  _signOut() async {
    try {
      setState(() {
        _loading = true;
      });
      await Auth().signOutUser();
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
    Future.delayed(Duration(milliseconds: 500), () async {
      if (!firstReward) {
        DatabaseService().addFranjas(context, franjas, 10);
        DatabaseService().saveFirstReward(true);
      }
    });
  }
}
