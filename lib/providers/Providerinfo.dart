import 'package:flutter/cupertino.dart';

class ProviderInfo with ChangeNotifier{
  int franjas = 0;

  void setFranjas(int franjas){
    this.franjas = franjas;
    notifyListeners();
  }

}