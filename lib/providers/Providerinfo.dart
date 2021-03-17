import 'package:flutter/cupertino.dart';
import 'package:franja_rojapp/models/ProfileModel.dart';

class ProviderInfo with ChangeNotifier {
  ProfileModel currentProfile;
  int selectedAnswer;
  String placeSelected;

  void setCurrentProfile(ProfileModel currentProfile) {
    this.currentProfile = currentProfile;
    notifyListeners();
  }

  void setSelectedAnswer(int selectedAnswer) {
    this.selectedAnswer = selectedAnswer;
  }

  void setSelectedPlace(String placeSelected) {
    this.placeSelected = placeSelected;
  }
}
