import 'package:flutter/material.dart';
import 'package:franja_rojapp/components/banner_franja_roja.dart';
import 'package:franja_rojapp/components/loading.dart';
import 'package:franja_rojapp/constants/constants.dart';
import 'package:franja_rojapp/services/auth.dart';

class ResetPassword extends StatefulWidget {
  ResetPassword({Key key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool _loading = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String email = "";
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
                Stack(children: <Widget>[
                  BannerFranjaRoja(),
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
                                  "Recuperación de contraseña",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    text:
                                        "Enviaremos un correo de recuperación a tu email registrado, recuerda revisar en spam y/o correos no deseados",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
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
                                  validator: (val) => val.isValidEmail()
                                      ? null
                                      : 'Ingresa un email válido',
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
                                    onPressed: () async => _resetPassword(),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text("Recuperar mi contraseña"),
                                      ],
                                    ),
                                  ),
                                ),
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

  _resetPassword() async {
    if (_formKey.currentState.validate()) {
      try{
        setState(() {
          _loading = true;
        });
        await Auth().sendPasswordreset(email);
        setState(() {
          _loading = false;
        });
          showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Aviso"),
              content: SingleChildScrollView(
                  child: Container(
                      child: Text("Recuperación enviada exitosamente a tu email, recuerda revisar bandeja, la lista de correos no deseados y spam"))),
              actions: [
                FlatButton(
                  child: Text("Aceptar"),
                  onPressed: () {
                    _formKey.currentState.reset();
                    _showLogin();
                  },
                ),
              ],
            ));
      }catch(e){
        simpleAlert(context, "Aviso", "El email ingresado no está registrado");
      }
    }
  }

  void _showLogin() {
    Navigator.of(context).pushReplacementNamed(
      '/auth',
    );
  }
}
