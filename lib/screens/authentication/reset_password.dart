import 'package:flutter/material.dart';
import 'package:franja_rojapp/components/loading.dart';

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
        : MaterialApp(
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
                                      style: TextStyle(fontSize: 14,
                                       color: Colors.black,
                                      )
                                      
                                      ,
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
            )),
          );
  }

  _resetPassword() {}
}
