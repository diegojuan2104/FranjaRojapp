import 'package:flutter/material.dart';
import 'package:franja_rojapp/components/main_appbar.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Glossary extends StatefulWidget {
  Glossary({Key key}) : super(key: key);

  @override
  _GlossaryState createState() => _GlossaryState();
}

class _GlossaryState extends State<Glossary> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      body: ListView(
        children: [
          SizedBox(
            height: 50,

          ),
          CarouselSlider( 
            options: CarouselOptions(
              height: 400,
              viewportFraction: 0.8
            ),
          ),
        ],
      )   
    );
  }
}
