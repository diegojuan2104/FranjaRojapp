import 'package:flutter/material.dart';

class BannerFranjaRoja extends StatelessWidget {
  const BannerFranjaRoja({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 30),
        decoration: BoxDecoration(color: Color(0xFFfC2c2C)),
        child: Container(
          margin: EdgeInsets.only(top: 20),
          child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "Franja Roja",
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'DancingScript',
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
