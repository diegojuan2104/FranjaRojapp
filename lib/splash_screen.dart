import 'package:flutter/material.dart';


class SplashScreeen extends StatefulWidget {
  @override
  _SplashScreeenState createState() => _SplashScreeenState();
}

class _SplashScreeenState extends State<SplashScreeen> {
  
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 3500), ()=> _showBigButtonPage());
    super.initState();
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FractionallySizedBox(
          widthFactor: .7,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              "assets/images/FranjaRojapp_logo_blanco.png",
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: RichText(
            
            textAlign: TextAlign.center,
            text: TextSpan(
              text:
                  'Una propuesta para mitigar la violencia basada en género en el contexto de la Universidad de Medellín',
              style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'BigShouldersDisplay',
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(height: 120,),
        CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),),
        SizedBox(height: 20,),
        RichText(
          textAlign: TextAlign.center,

          text: TextSpan(
            text:
                'Cargando...',
            style: TextStyle(
                fontSize: 18,
                fontFamily: 'BigShouldersDisplay',
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ));
  }
  void _showBigButtonPage() {
    Navigator.of(context).pushReplacementNamed(
      '/bigButtonPage',
    );
  }
}
