import 'package:flutter/material.dart';
import 'package:franja_rojapp/screens/big_button_page.dart';
import 'package:franja_rojapp/screens/login.dart';
import 'package:franja_rojapp/services/auth.dart';
import 'package:franja_rojapp/screens/splash_screen.dart';
import 'package:flutter/services.dart';
import 'package:franja_rojapp/screens/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import '../models/user_model.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      ([DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final MaterialColor kPrimaryColor = const MaterialColor(
    0xFFfC2c2C,
    const <int, Color>{
      50: Color(0xFFFFEBEE),
      100: Color(0xFFFFCDD2),
      200: Color(0xFFEF9A9A),
      300: Color(0xFFE57373),
      400: Color(0xFFEF5350),
      500: Color(0xFFfC2c2C),
      600: Color(0xFFE53935),
      700: Color(0xFFD32F2F),
      800: Color(0xFFC62828),
      900: Color(0xFFB71C1C),
    },
  );

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User_model>.value(
      value: Auth().user,
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: kPrimaryColor,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          onGenerateRoute: (RouteSettings settings) {
            return MaterialPageRoute(builder: (BuildContext context) {
              switch (settings.name) {
                case "/":
                  return SplashScreeen();

                case "/bigButtonPage":
                  return BigButtonPage();

                case "/auth":
                  return Wrapper();
              }
            });
          }),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}