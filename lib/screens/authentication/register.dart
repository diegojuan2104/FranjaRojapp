import 'package:flutter/material.dart';
import 'package:franja_rojapp/constants/simpleAlert.dart';
import 'package:franja_rojapp/services/auth.dart';

class Register extends StatefulWidget {
  Register({Key key}) : super(key: key);
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool termsAndConditions = false;

  bool _loading = false;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String email = "";
  String password = "";
  String password_confirmation = "";
  String _errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Stack(
            children: [
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
            ],
          ),
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
                            "Registrarse",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextFormField(
                            decoration: InputDecoration(labelText: "Email"),
                            onChanged: (val) {
                              setState(() => email = val);
                            },
                            validator: (val) => val.isValidEmail()
                                ? null
                                : "Ingresa un email válido",
                          ),
                          TextFormField(
                            decoration:
                                InputDecoration(labelText: "Contraseña"),
                            obscureText: true,
                            onChanged: (val) {
                              setState(() => password = val);
                            },
                            validator: (val) => val.length < 6
                                ? 'La contraseña debe ser mayor a 6 dígitos'
                                : null,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: "Confirmar contraseña"),
                            obscureText: true,
                            onChanged: (val) {
                              setState(() => password_confirmation = val);
                            },
                            validator: (val) => val.length < 1
                                ? 'Debes confirmar tu contraseña'
                                : null,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Checkbox(
                                value: termsAndConditions,
                                onChanged: (bool value) {
                                  setState(() {
                                    termsAndConditions = value;
                                  });
                                },
                              ),
                              FlatButton(
                                textColor: Theme.of(context).primaryColor,
                                child: Text(
                                  "Términos y condiciones",
                                  style: TextStyle(
                                      fontSize: 12,
                                      decoration: TextDecoration.underline),
                                ),
                                onPressed: () {
                                  _showTermsAndConditions();
                                },
                              )
                            ],
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
                            height: 20,
                          ),
                          Theme(
                            data: Theme.of(context)
                                .copyWith(accentColor: Colors.white),
                            child: RaisedButton(
                              color: Theme.of(context).primaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              textColor: Colors.white,
                              onPressed: () async => _registerEmail(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("Registrarse"),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                FlatButton(
                                  textColor: Theme.of(context).primaryColor,
                                  child: Text("Ya tengo una cuenta"),
                                  onPressed: () {
                                    _showLogin();
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
    ));
  }

  _registerEmail() async {
    if (_formKey.currentState.validate()) {
      if (password == password_confirmation) {
        if (termsAndConditions) {
          await Auth().registerWithEmailAndPassword(email, password);

          await Auth().sendVerificationEmail();
          await Auth().signOutUser();
          simpleAlert(context, "Aviso", "Usuario registrado exitosamente");
        } else {
          simpleAlert(context, "Aviso",
              "Debes aceptar los términos y condiciones para continuar con el registro");
          setState(() {
            _errorMessage =
                "Debes aceptar los terminos y condiciones para registrarte";
          });
        }
      } else {
        simpleAlert(context, "Avisto", "Las contraseñas deben de coincidir");
        setState(() {
          _errorMessage = "Las contraseñas debende de coincidir";
        });
      }
    }
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
                        setState(() {
                          termsAndConditions = true;
                        });
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            ));
  }

  void _showLogin() {
    Navigator.of(context).pushNamed(
      '/auth',
    );
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}
