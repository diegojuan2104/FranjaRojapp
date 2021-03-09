import 'package:flutter/material.dart';
import 'package:franja_rojapp/components/main_appbar.dart';
import 'package:franja_rojapp/providers/ProviderInfo.dart';
import 'package:franja_rojapp/providers/data.dart';
import 'package:franja_rojapp/screens/authentication/register.dart';
import 'package:franja_rojapp/screens/authentication/reset_password.dart';
import 'package:franja_rojapp/screens/menu/avatar.dart';
import 'package:franja_rojapp/screens/menu/glossary.dart';
import 'package:franja_rojapp/screens/menu/home.dart';
import 'package:franja_rojapp/screens/initial_screens/big_button_page.dart';
import 'package:franja_rojapp/screens/authentication/login.dart';
import 'package:franja_rojapp/screens/menu/question.dart';
import 'package:franja_rojapp/screens/menu/glossary.dart';
import 'package:franja_rojapp/services/auth.dart';
import 'package:franja_rojapp/screens/initial_screens/splash_screen.dart';
import 'package:flutter/services.dart';
import 'package:franja_rojapp/screens/authentication/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

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
    return MultiProvider(
      providers: [
        Provider<Auth>(
          create: (_) => Auth(),
        ),
        ChangeNotifierProvider<ProviderInfo>(
          create: (_) => ProviderInfo(),
        ),
        StreamProvider(
          create: (context) => context.read<Auth>().authStateChanges,
        ),
        ChangeNotifierProvider<Data>(create: (context) => Data()),

      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: kPrimaryColor,
            primaryColor: kPrimaryColor,
            accentColor: kPrimaryColor,
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
                case "/login":
                  return Login();
                case "/register":
                  return Register();
                case "/home":
                  return Home();
                case "/reset_password":
                  return ResetPassword();
                case "/avatar":
                  return AvatarPage();
                case "/question":
                  return Question();
                case "/appbar":
                  return MainAppBar();
                case "/glossary":
                  return Glossary();
                case "/test":
                  return Glossary();
              }
            });
          }),
    );
  }

  getFranjas() {}
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
        child: Text(""),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
