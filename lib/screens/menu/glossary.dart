import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:franja_rojapp/components/glossary_card.dart';
import 'package:franja_rojapp/components/main_appbar.dart';
import 'package:franja_rojapp/constants/constants.dart';
import 'package:franja_rojapp/providers/Providerinfo.dart';
import 'package:franja_rojapp/services/database.dart';
import 'package:provider/provider.dart';
import '../../providers/Providerinfo.dart';

class Glossary extends StatefulWidget {
  Glossary({Key key}) : super(key: key);

  @override
  _GlossaryState createState() => _GlossaryState();
}

class _GlossaryState extends State<Glossary> {
  ProviderInfo prov;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    validateGlossaryOpened();
  }

  int total = 5;
  int _currentPage;
  List cardsViewed = [];
  @override
  Widget build(BuildContext context) {
    prov = Provider.of<ProviderInfo>(context);
    MediaQueryData queryData = MediaQuery.of(context);
    return Scaffold(
      appBar: MainAppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: queryData.size.height * 0.05,
            ),
            CarouselSlider(
              items: [
                //1st Image of Slider
                GlosaryCard(
                  title: "Sexo",
                  example: "Femenino \nMasculino \nIntersexual",
                  content:
                      "Reúne la configuración de las corporalidades de cada individuo en razón de cinco características fisiológicas: genes, gónadas, hormonas, órganos reproductivos internos y genitales.",
                  index: 1,
                  total: total,
                ),
                GlosaryCard(
                  title: "Género",
                  content:
                      "Es una categoría que analiza cómo se definen, representan y simbolizan las diferencias sexuales de una sociedad. \nLo que determina la identidad y el comportamiento de cada ser no es el sexo biológico, sino las expectativas sociales, los ritos, costumbres y experiencias.",
                  index: 2,
                  total: total,
                ),
                GlosaryCard(
                  title: "Identidad de Género",
                  example:
                      "Mujer \nHombreTrans \nMujer Trans \nHombre Binario \nGénero Fluido",
                  content:
                      "La identidad designa aquello que es propio de un individuo o grupo, y singulariza. Las expresiones de la identidad varían en función de las referencias culturales, profesionales, religiosas, geográficas y lingüísticas, entre otras. A pesar de su vaguedad semántica, el concepto de identidad permite esclarecer las relaciones entre el individuo y su entorno.",
                  index: 3,
                  total: total,
                ),
                GlosaryCard(
                  title: "Violencia basada en Género",
                  content:
                      "La violencia basada en género es todo acto de violencia directa o sutil producida en la vida pública o privada, que pretende maltratar, lesionar y agredir basado en el género o la preferencia sexual de la víctima.",
                  index: 4,
                  total: total,
                ),
                GlosaryCard(
                  title: "Perspectiva de Género",
                  content:
                      "La perspectiva de género es una herramienta conceptual que busca mostrar que las diferencias entre mujeres y hombres se dan no sólo por su determinación biológica, sino también por las diferencias culturales asignadas a los seres humanos.",
                  index: 5,
                  total: total,
                ),
              ],
              //Slider Container properties
              options: CarouselOptions(
                initialPage: 0,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentPage = index;
                  });
                  if (!cardsViewed.contains(index)) {
                    cardsViewed.add(index);
                    if (cardsViewed.length == total) {
                      validateGlossaryReward();
                    }
                  }
                },
                height: queryData.size.height * 0.95,
                enlargeCenterPage: true,
                aspectRatio: 16 / 9,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                viewportFraction: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void validateGlossaryOpened() {
    Future.delayed(Duration(milliseconds: 500), () async {
      if (prov.currentProfile != null) {
        if (!prov.currentProfile.glossary_opened) {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => AlertDialog(
                    title: Text("Te damos la bienvenida al Glosario Rojo "),
                    content: SingleChildScrollView(
                        child: Container(
                            child: Column(children: <Widget>[
                      RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          text:
                              'Este espacio te brindará una pequeña introducción terminológica. Es decir, que te permitirá reconocer cinco términos bases transversales a la temática de violencias basadas en género.\n\nPuedes desplazarte por el glosario con el siguiente movimiento:',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Image.asset(
                        "assets/images/slidegesture.gif",
                        height: 125.0,
                        width: 200,
                      ),
                    ]))),
                    actions: [
                      FlatButton(
                        child: Text("Aceptar"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ));
        }
      }
    });
  }

  void validateGlossaryReward() async {
    if (prov.currentProfile.glossary_opened) return;

    await DatabaseService()
        .addFranjas(context, prov.currentProfile.franjas, 10);

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              title: Text("¡Felicidades!"),
              content: SingleChildScrollView(
                  child: Container(
                      child: Text(
                          "Has ganado 10 Franjitas por haber observado la totalidad del Glosario Rojo. Te invitamos a continuar explorando FranjARojApp. "))),
              actions: [
                FlatButton(
                  child: Text("Aceptar"),
                  onPressed: () async {
                    await DatabaseService().saveGlossaryOpened(true);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }
}
