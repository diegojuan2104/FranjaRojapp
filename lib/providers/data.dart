import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:franja_rojapp/constants/constants.dart';
import 'package:franja_rojapp/models/ProfileModel.dart';
import 'package:franja_rojapp/models/avatar_grid_part.dart';
import 'package:franja_rojapp/models/avatar_stack_part.dart';
import 'package:franja_rojapp/providers/Providerinfo.dart';
import 'package:franja_rojapp/services/database.dart';

class Data with ChangeNotifier {
  bool successDrop;
  List<AvatarP> items;
  AvatarP acceptedData;
  ProfileModel currentProfile;
  String a = '';
  double sizeW, sizeH = 0;
  int numFran = 0;
  List<List<dynamic>> listaTabs = [];
  double _sizeTrash = 0;
  Map<String, List<double>> mapMesuares = {};
  Map<String, List<AvatarModel>> mapItems = {};
  List<Color> _colorList = [];
  Uint8List imgAv = null;
  int cont = 1;
  Color _avColor = Colors.black;

  set currentProf(ProfileModel p) {
    this.currentProfile = p;
    dynamic lista = p.avatar_position;
    if (lista != null) {
      if (lista.length > 0) {
        dynamic list = lista[0]["DataAvatar"];
        for (var l in list) {
          if (cont == 1) {
            items.add(AvatarP(
              path: l['path'],
              top: l['top'],
              left: l['left'],
              type: l['type'],
              sizew: l['sizew'],
              sizeh: l['sizeh'],
            ));
          }
        }
        cont++;
      }
    }
    notifyListeners();
  }

  Map sizeAvatar() {
    return this.mapMesuares = Constants.getMesureMap(this.sizeW, this.sizeH);
  }

  set setImg(Uint8List img) {
    this.imgAv = img;
    notifyListeners();
  }

  void avColor(Color color) {
    this._avColor = color;
    notifyListeners();
  }

  get getavColor => _avColor;
  set sizeTrah(double value) {
    this._sizeTrash = value;
    notifyListeners();
  }

  get colorList => _colorList;
  get sizeTrash => _sizeTrash;
  set setA(String value) {
    a = value;
    notifyListeners();
  }

  bool validateTypeExist(AvatarP item) {
    for (var val in items) {
      if (item.type == val.type) {
        return true;
      }
    }
    return false;
  }

  void addElementList(AvatarP item) {
    bool exist = false;
    if (validateTypeExist(item)) {
      return;
    }
    items.add(item);
    notifyListeners();
  }

  bool validateFranjas(AvatarModel item) {
    return numFran >= item.numFranjas;
  }

  void deleteFromList(AvatarP item) {
    int aux = -1;
    List<AvatarP> auxL = [];
    for (var i = 0; i < items.length; i++) {
      if (item.path == items[i].path) continue;
      auxL.add(items[i]);
    }
    this.items = auxL;
    notifyListeners();
  }

  List<dynamic> getListTabs({ScrollController s}) {
    final parameters = [
      'ojos',
      'boca',
      'nariz',
      'orejas',
      'mascotas',
      'figuras',
      'cuerpo',
      'plantas',
      'cabellos'
    ];
    final names = [
      "Ojos",
      "Boca",
      "Nariz",
      "Orejas",
      "Mascotas",
      "Figuras",
      "Partes Cuerpo",
      "Plantas",
      "Cabello",
      "Colores",
    ];
    if (s != null)
      return Constants.createListTabs(parameters, s);
    else
      return Constants.createListWTabs(names);
  }

  Data() {
    successDrop = false;
    items = [];
    this.mapItems = Constants.initializMap();
    this._colorList = Constants.initializMapColors();
  }

  void setValueListTop(int i, double value) {
    if (i < items.length) {
      items[i].top = value;
      notifyListeners();
    }
  }

  void setValueListLeft(int i, double value) {
    if (i < items.length) {
      items[i].left = value;
      notifyListeners();
    }
  }

  bool get isSuccessDrop => successDrop;
  List<AvatarP> get itemsList => items;
  AvatarP get getAcceptedData => acceptedData;

  set setSuccessDrop(bool status) {
    successDrop = status;
    notifyListeners();
  }

  changeAcceptedData(AvatarP data) {
    acceptedData = data;
    notifyListeners();
  }

  changeSuccessDrop(bool status) {
    setSuccessDrop = status;
  }

  removeLastItem() {
    items.removeLast();
    notifyListeners();
  }

  addItemToList(AvatarP item) {
    items.add(item);
    notifyListeners();
  }

  initializeDraggableList() {
    items = [];
    notifyListeners();
  }
}
