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
  void dispose(){
    super.dispose();
  }

  @override
  void initState() { 
    super.initState();
    validateGlossaryOpened();
  }

  int total = 5;
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
                  content:
                      "Reúne la configuración de las corporalidades de cada individuo en razón de cinco características fisiológicas: genes, gónadas, hormonas, órganos reproductivos internos y genitales",
                  index: 1,
                  total: total,
                ),
                GlosaryCard(
                  title: "Ge'nero",
                  content:
                      "Es una categoría que analiza cómo se definen, representan y simbolizan las diferencias sexuales de una sociedad \nLo que determina la identidad y el comportamiento de casa ser no es el sexo biológico, sino las expectativas sociales, los ritos, costumbres y experiencias",
                  index: 2,
                  total: total,
                ),
                GlosaryCard(
                  title: "IDenTidad de Ge'nero",
                  content:
                      "La identidad designa aquello que es propio de un individuo o grupo y singulariza. Las expresiones de la identidad varían en función de las referencias culturales, profesionales, religiosas, geográficas y lingüísticas, entre otras. A pesar de su vaguedad semántica, el concepto de identidad permite esclarecer las relaciones entre el individuo y su entorno",
                  index: 3,
                  total: total,
                ),
                GlosaryCard(
                  title: "Violencia de Ge'nero",
                  content:
                      "La violencia de género es todo acto de violencia directa o sutil producido en la vida pública o en la privada, que pretende maltratar, lesionar y agredir basado en el género o la preferencia sexual de la víctima ",
                  index: 4,
                  total: total,
                ),
                GlosaryCard(
                  title: "Perspectiva de Ge'nero",
                  content:
                      "La perspectiva de género es una herramienta conceptual que busca mostrar que las diferencias entre mujeres y hombres se dan no sólo por su determinación biológica, sino también por las diferencias culturales asignadas a los seres humanos",
                  index: 5,
                  total: total,
                ),
              ],
              //Slider Container properties
              options: CarouselOptions(
                height: queryData.size.height * 0.95,
                enlargeCenterPage: true,
                aspectRatio: 16 / 9,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                viewportFraction: 0.95,
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
          simpleAlert(
              context, "Te damos la bienvenida al glosario rojo", "Es una introducción al reconocimiento de las violencias basadas en género en el contexto de la Universidad de Medellín. Acá encontrarás 5 términos bases: sexo, género, identidad de género, perspectiva de género y violencia de género, cada una de ellos acompañado de un ejemplo.");
          simpleAlert(
              context, "Felicidades", "Has ganado 10 franjitas por darle un vistazo al glosario!");
         await DatabaseService()
              .addFranjas(context, prov.currentProfile.franjas, 10);
          await DatabaseService().saveGlossaryOpened(true);
          
        }
      }
    });
  }
}
