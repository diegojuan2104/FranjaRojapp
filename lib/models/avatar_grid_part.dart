import 'package:flutter/material.dart';

class AvatarModel {
  final String image;
  final Color color;
  double sizew;
  double sizeh;
  int numFranjas;
  AvatarModel(
      {this.image,
      this.color,
      this.sizeh = 1,
      this.sizew = 1,
      this.numFranjas = 8});
}

List<AvatarModel> getListFilled() {
  List<AvatarModel> avMod = [];
  int fila, cont = 0;

  for (var i = 0; i < 20; i++) {
    Color auxx = Colors.white;
    avMod.add(AvatarModel(
        image: "assets/images/boca_av-removebg-preview.png",
        color: i % 2 == 0 ? Colors.red[50] : Colors.blue[50]));
  }
  return avMod;
}
