import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:franja_rojapp/constants/constants.dart';
import 'package:franja_rojapp/models/avatar_grid_part.dart';
import 'package:franja_rojapp/models/avatar_stack_part.dart';
import 'package:franja_rojapp/providers/Providerinfo.dart';
import 'package:franja_rojapp/providers/data.dart';
import 'package:franja_rojapp/screens/menu/question.dart';
import 'package:franja_rojapp/services/database.dart';
import 'package:provider/provider.dart';

class TabWidget extends StatelessWidget {
  const TabWidget(
      {Key key,
      @required this.scrollController,
      @required this.parameter,
      @required this.c})
      : super(key: key);
  final ScrollController scrollController;
  final String parameter;
  final Function c;
  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<Data>(context);
    final prov2 = Provider.of<ProviderInfo>(context);
    return buildColumn(prov, prov2, parameter, scrollController, c);
  }
}

Column buildColumn(
    Data prov, ProviderInfo prov2, String parameter, scrol, Function c) {
  final list = prov.mapItems[parameter];
  return Column(
    children: [
      Expanded(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: GridView.builder(
            controller: scrol,
            itemCount: list.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 20,
                crossAxisSpacing: 10,
                crossAxisCount: 2,
                childAspectRatio: 0.8 - (-1 * (0.8 - prov.sizeH * 0.00108))),
            itemBuilder: (context, index) => AvatarCard(
              avatar: list[index],
              press: () {
                final numF = prov2.currentProfile.franjas;
                final canI = prov.validateFranjas(list[index], numF);
                AvatarModel avAux = list[index];
                final av = AvatarP(
                    path: avAux.image,
                    type: parameter,
                    sizeh: avAux.sizeh,
                    sizew: avAux.sizew);
                final exist = prov.validateTypeExist(av);
                if (avAux.numFranjas == 0) {
                  Constants.Dialog(context, 'Mensaje',
                      'Para elegir alguno de estos items debe responder una pregunta, ¿Deseas responderla? ',
                      () async {
                    bool answered = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Question()),
                    );
                    answered = answered ?? true;
                    if (answered) {
                      if (!exist) {
                        c();
                        prov.addElementList(av);
                      } else {
                        Constants.Dialog(
                            context,
                            " Mensaje ",
                            "Ya tienes un elemento de este tipo. Si deseas escoger uno nuevo, debes eliminar el que posees actualmente.",
                            () {},
                            () {});
                      }
                    }
                  }, () {});
                } else {
                  if (!exist) {
                    if (canI) {
                      Constants.Dialog(context, "¡Atención!",
                          "¿Deseas continuar con la compra de este ítem? Recuerda que no tendrá devoluciones.",
                          () {
                        prov.addElementList(av);
                        prov2.currentProfile
                            .setFranjas(-list[index].numFranjas);
                        DatabaseService()
                            .addFranjas(context, numF, -list[index].numFranjas);
                        Constants.Dialog(context, 'Mensaje',
                            'Item exitosamente comprado, ahora puedes moverlo como quieras.',
                            () {
                          c();
                        }, () {});
                      }, () {});
                    } else {
                      Constants.Dialog(context, 'Mensaje',
                          'No tienes las Franjitas necesarias para comprar este elemento. ¿Deseas responder una pregunta para obtener Franjitas?',
                          () {
                        Navigator.pushNamed(context, "/question");
                      }, () {});
                    }
                  } else {
                    Constants.Dialog(
                        context,
                        " Mensaje ",
                        "Ya tienes un elmento de este tipo, por favor eliminalo y podrás escoger uno nuevo.",
                        () {},
                        () {});
                  }
                }
              },
              width: prov.sizeW,
              height: prov.sizeH,
            ),
          ),
        ),
      ),
    ],
  );
}

class AvatarCard extends StatelessWidget {
  final AvatarModel avatar;
  final Function press;
  final width;
  final height;
  const AvatarCard(
      {Key key,
      @required this.avatar,
      @required this.press,
      @required this.width,
      @required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: SizedBox(
        height: height * 0.305,
        width: width * 0.418,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
            decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFfC2c2C)),
                color: avatar.color,
                borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: height * 0.205,
                  width: width * 0.418,
                  child: Container(
                    child: Image.asset(avatar.image),
                  ),
                ),
                SizedBox(
                  height: 50,
                  width: width * 0.418,
                  child: Container(
                      child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "${avatar.numFranjas} F",
                      style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'Silvertone',
                          color: Colors.red,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/**
 * Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: press,
          child: SizedBox(
            height: height*0.205,
            width: width*0.418,
            child: Container(
              //height: 180,
              //width: 150,
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFfC2c2C)),
                  color: avatar.color, borderRadius: BorderRadius.circular(16)),
              child: Image.asset(avatar.image),
            ),
          ),
        ),
      ],
    );
 *  Column(
              children: [
                Container(
                  //height: 180,
                  //width: 150,
                  padding: EdgeInsets.all(30),
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFfC2c2C)),
                      color: avatar.color,
                      borderRadius: BorderRadius.circular(16)),
                  child: Image.asset(avatar.image),
                ),
                Container(
                    child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "${avatar.numFranjas}",
                    style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'Silvertone',
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ))
              ],
            ),
 */
