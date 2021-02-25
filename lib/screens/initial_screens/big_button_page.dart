import 'package:flutter/material.dart';
import 'package:franja_rojapp/components/loading.dart';

class BigButtonPage extends StatefulWidget {
  BigButtonPage({Key key}) : super(key: key);

  @override
  _BigButtonPageState createState() => _BigButtonPageState();
}

class _BigButtonPageState extends State<BigButtonPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  double _scale;
  bool loading = false;

  @override
  void initState() { 
    super.initState();
    _controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 200),
        lowerBound: 0.0,
        upperBound: 0.1)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    return loading? Loading() : MaterialApp(
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
            Center(
              child: GestureDetector(
                onTapDown: _onTapDown,
                onTapUp: _onTapUp,
                child: Transform.scale(
                  scale: _scale,
                  child: _animatedbuttonUi,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text:
                      'Una propuesta para mitigar la violencia basada en género en el contexto de la Universidad de Medellín',
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'BigShouldersDisplay',
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        )),
    );
  }

  Widget get _animatedbuttonUi => Container(
      height: 220,
      width: 220,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border:
            Border.all(width: 2, color: Colors.black, style: BorderStyle.solid),
        boxShadow: [
          BoxShadow(
              color: Color(0x80000000),
              offset: Offset(0.0, 5.0),
              blurRadius: 12.0),
        ],
        gradient: LinearGradient(
          colors: [
            Color(0xFFFFFFFF),
            Color(0xFFFFFFFF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: 'Acompañanos a construir una UdeM que ya no calle',
            style: TextStyle(
                fontSize: 20,
                fontFamily: 'BigShouldersDisplay',
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
        ),
      ));

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
    
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    loading = true;
    Future.delayed(Duration(milliseconds: 700), ()=> {
      loading = false,
      _showLogin()}
      );
  }

  void _showLogin() {
    Navigator.of(context).pushReplacementNamed(
      '/auth',
    );
  }
}
