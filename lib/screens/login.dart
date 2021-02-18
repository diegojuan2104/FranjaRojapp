import 'dart:math';

import 'package:flutter/material.dart';
import 'package:franja_rojapp/services/auth.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _loading = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String _errorMessage = "";

  @override
  Widget build(BuildContext context) {
    double phone_height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
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
          Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(
                        left: 20, right: 20, top: 20, bottom: 20),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 35, vertical: 20),
                      child: Column(
                        children: <Widget>[
                          Text(
                            "Iniciar Sesión",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextFormField(
                            decoration: InputDecoration(labelText: "Email"),
                            onChanged: (val) {
                              setState(() => email = val);
                            },
                            validator: (val) =>
                                val.isEmpty ? 'Este campo es obligatorio' : null,
                          ),
                          TextFormField(
                            validator: (val) => val.length == 0
                                ? 'Este campo es obligatorio'
                                : null,
                            decoration:
                                InputDecoration(labelText: "Contraseña"),
                            obscureText: true,
                            onChanged: (val) {
                              setState(() => password = val);
                            },
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Theme(
                            data: Theme.of(context)
                                .copyWith(accentColor: Colors.white),
                            child: RaisedButton(
                              color: Theme.of(context).primaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              
                              textColor: Colors.white,
                              onPressed: () async => _loginEmail(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
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
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              textColor: Colors.black,
                              onPressed: () => _loginWithGoogle(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Tab(
                                    icon: Container(
                                      margin:
                                          const EdgeInsets.only(right: 10.0),
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
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("¿No estás registrado?"),
                                FlatButton(
                                  textColor: Theme.of(context).primaryColor,
                                  child: Text("Registrarse"),
                                  onPressed: () {
                                    double height =
                                        MediaQuery.of(context).size.height;
                                    print("height" + height.toString());
                                    _showRegister();
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

  _loginEmail() async {
    print("email" + email);
    print("password" + password);
    if (_formKey.currentState.validate()) {
      setState(() {
        _loading = true;
      });
      dynamic result =
          await Auth().signInWithEmailAndPassword(email,password );
      print(result);
      if (result == null) {
        setState(() {
          _errorMessage = 'Email,  password incorrect';
          _loading = false;
        });
      } else {}
    }
  }

  void _showRegister() {}

  _loginWithGoogle() {
    Auth().signInUserWithGoogle();
  }
}
