import 'package:flutter/material.dart';
import 'package:franja_rojapp/components/loading.dart';
import 'package:franja_rojapp/constants/constants.dart';
import 'package:franja_rojapp/services/auth.dart';
import 'package:franja_rojapp/services/database.dart';

class Register extends StatefulWidget {
  Register({Key key}) : super(key: key);
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool termsAndConditions = false;

  bool _loading = false;
  bool _showPassword = false;
  bool _showPassword_confirmation = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String password_confirmation = "";
  String _errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Loading()
        : Scaffold(
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
                          height: 65,
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
                                  "Registro",
                                  style: TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.bold,),
                                ),
                                TextFormField(
                                  decoration:
                                      InputDecoration(labelText: "Email"),
                                  onChanged: (val) {
                                    setState(() => email = val);
                                  },
                                  validator: (val) => val.trim().isValidEmail()
                                      ? null
                                      : "Ingresa un email válido",
                                ),
                                TextFormField(
                                  decoration: InputDecoration(
                                      labelText: "Contraseña",
                                      suffixIcon: IconButton(
                                        icon: Icon(_showPassword
                                            ? Icons.visibility
                                            : Icons.visibility_off),
                                        onPressed: () {
                                          setState(() {
                                            _showPassword = !_showPassword;
                                          });
                                        },
                                      )),
                                  obscureText: !_showPassword,
                                  onChanged: (val) {
                                    setState(() => password = val);
                                  },
                                  validator: (val) => val.length < 6
                                      ? 'La contraseña debe ser mayor a 6 dígitos'
                                      : null,
                                ),
                                TextFormField(
                                  decoration: InputDecoration(
                                      labelText: "Confirmar contraseña",
                                      suffixIcon: IconButton(
                                        icon: Icon(_showPassword_confirmation
                                            ? Icons.visibility
                                            : Icons.visibility_off),
                                        onPressed: () {
                                          setState(() {
                                            _showPassword_confirmation = !_showPassword_confirmation;
                                          });
                                        },
                                      )),
                                  obscureText: !_showPassword_confirmation,
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
                                            decoration:
                                                TextDecoration.underline),
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
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                          ),
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
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    textColor: Colors.white,
                                    onPressed: () async => _registerEmail(),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                        textColor:
                                            Theme.of(context).primaryColor,
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
          try {
            setState(() {
              _loading = true;
            });
            await Auth().registerWithEmailAndPassword(email.trim(), password);
            await Auth().sendVerificationEmail();
            await Auth().signOutUser();

            setState(() {
              _loading = false;
            });
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: Text("Aviso"),
                      content: SingleChildScrollView(
                          child: Container(
                              child: Text(
                                  "Usuario registrado exitosamente, debes validar tu cuenta con tu email registrado, recuerda revisar la bandeja la lista de correos no deseados o spam"))),
                      actions: [
                        FlatButton(
                          child: Text("Aceptar"),
                          onPressed: () {
                            setState(() {
                              _formKey.currentState.reset();
                              setState(() {
                                termsAndConditions = false;
                              });
                            });
                            Navigator.pop(context);
                            _showLogin();
                          },
                        ),
                      ],
                    ));
          } catch (e) {
            simpleAlert(
                context, "Aviso", "El email es inválido o ya está en uso");
            setState(() {
              _loading = false;
            });
          }
        } else {
          simpleAlert(context, "Aviso",
              "Debes aceptar los términos y condiciones para continuar con el registro");
          setState(() {
            _errorMessage =
                "Debes aceptar los terminos y condiciones para registrarte";
          });
        }
      } else {
        simpleAlert(context, "Avisto", "Las contraseñas deben coincidir");
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
                        TERMINOS_Y_CONDICIONES
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
    Navigator.pop(context);
  }
}
