import 'package:flutter/material.dart';
import 'package:franja_rojapp/components/loading.dart';
import 'package:franja_rojapp/services/auth.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

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
  var termsAndConditions = false;
  bool _loading = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String _errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Loading()
        : MaterialApp(
           theme: ThemeData(
            primarySwatch: kPrimaryColor,
            primaryColor:kPrimaryColor ,
            accentColor: kPrimaryColor,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
            home: Scaffold(
                body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Stack(children: <Widget>[
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 30),
                      decoration: BoxDecoration(color: Color(0xFFfC2c2C)),
                      child: Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Image.asset(
                          "assets/images/FranjaRojapp_logo_blanco.png",
                          color: Colors.white,
                          height: 80,
                        ),
                      ),
                    ),
                    SizedBox(
                      child: AppBar(
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                      ),
                      height: kToolbarHeight + 25,
                    ),
                  ]),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(
                                left: 10, right: 10, top: 10, bottom: 10),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 35, vertical: 20),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    "Iniciar Sesión",
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    decoration:
                                        InputDecoration(labelText: "Email"),
                                    onChanged: (val) {
                                      setState(() => email = val);
                                    },
                                    validator: (val) => val.isEmpty
                                        ? 'Este campo es obligatorio'
                                        : null,
                                  ),
                                  TextFormField(
                                    validator: (val) => val.length == 0
                                        ? 'Este campo es obligatorio'
                                        : null,
                                    decoration: InputDecoration(
                                        labelText: "Contraseña"),
                                    obscureText: true,
                                    onChanged: (val) {
                                      setState(() => password = val);
                                    },
                                  ),
                                  if (_errorMessage.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        _errorMessage,
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  SizedBox(
                                    height: 40,
                                  ),
                                  Theme(
                                    data: Theme.of(context)
                                        .copyWith(accentColor: Colors.white),
                                    child: RaisedButton(
                                      color: Theme.of(context).primaryColor,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15),
                                      textColor: Colors.white,
                                      onPressed: () async => _loginEmail(),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text("Iniciar Sesión"),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Theme(
                                    data: Theme.of(context)
                                        .copyWith(accentColor: Colors.white),
                                    child: RaisedButton(
                                      color: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      textColor: Colors.black,
                                      onPressed: () =>
                                          _showTermsAndConditions(),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Tab(
                                            icon: Container(
                                              margin: const EdgeInsets.only(
                                                  right: 10.0),
                                              child: Image(
                                                image: AssetImage(
                                                  'assets/images/google.png',
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                              height: 30,
                                              width: 30,
                                            ),
                                          ),
                                          Text("Iniciar Sesión con Google"),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text("¿No estás registrado?"),
                                        FlatButton(
                                          textColor:
                                              Theme.of(context).primaryColor,
                                          child: Text("Registrarse"),
                                          onPressed: () {
                                            _showRegister();
                                          },
                                        )
                                      ]),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        FlatButton(
                                          textColor:
                                              Theme.of(context).primaryColor,
                                          child: Text("Olvidé mi contraseña"),
                                          onPressed: () {
                                            _forgotMyPassword();
                                          },
                                        )
                                      ]),
                                ],
                              ),
                            ),
                          )
                        ],
                      ))
                ],
              ),
            )),
          );
  }

  _loginEmail() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _loading = true;
      });
      dynamic result = await Auth().signInWithEmailAndPassword(email, password);

      print(result);
      if (result == null) {
        setState(() {
          _errorMessage = 'Correo y/o contraseña incorrecta';
        });
      } else {
        if (!Auth().emailIsVerified()) {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text("Aviso"),
                    content: SingleChildScrollView(
                        child: Container(
                            child: Text(
                                "Debes verificar la email para continuar, revisa tu bandeja de entrada incluyendo correos no deseados o spam, si no encuentras el correo te recomendamos iniciar sesión con Google"))),
                    actions: [
                      FlatButton(
                        child: Text("Aceptar"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ));
          Auth().signOutUser();
          _errorMessage = "El email no ha sido verificado revise su correo";
        }
      }
    }
  }

  void _showRegister() {
    setState(() {
      _loading = true;
    });
    Future.delayed(
        Duration(milliseconds: 300),
        () => {
              Navigator.of(context).pushNamed(
                '/register',
              ),
              Future.delayed(
                  Duration(milliseconds: 300),
                  () => {
                        setState(() {
                          _loading = false;
                        }),
                      }),
            });
  }

  _loginWithGoogle() async {
    setState(() {
      _loading = true;
    });
    await Auth().signInUserWithGoogle();
    setState(() {
      _loading = true;
    });
  }

  void _showTermsAndConditions() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Términos y condiciones"),
              content: SingleChildScrollView(
                  child: Container(
                      child: Text(
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).",
              ))),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    FlatButton(
                      child: Text("Cancelar"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      child: Text("Aceptar"),
                      onPressed: () {
                        _loginWithGoogle();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            ));
  }

  void _forgotMyPassword() {
     Navigator.of(context).pushNamed(
                '/reset_password',
    );
  }
}
