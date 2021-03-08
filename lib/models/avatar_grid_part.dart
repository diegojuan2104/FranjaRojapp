import 'package:flutter/material.dart';

class AvatarModel{
  final String image;
  final Color color;
  int numFranjas = 0;
  AvatarModel({
    this.image,this.color
  });

}
List<AvatarModel> getListFilled(){
List<AvatarModel> avMod = [];
  int fila,cont = 0; 
  

  for (var i = 0; i < 20; i++) {
    
    Color aux = Colors.white;
      avMod.add(AvatarModel(image: "assets/images/boca_av-removebg-preview.png",color: i %2 == 0 ? Colors.red[50] : Colors.blue[50]));
  
     
    

  }
  return avMod;
}


