import 'package:flutter/cupertino.dart';
import 'package:franja_rojapp/models/profileModel.dart';

class ProviderInfo with ChangeNotifier{
  
  ProfileModel currentProfile;
  int selectedAnswer;

  void setCurrentProfile(ProfileModel currentProfile){
    this.currentProfile = currentProfile;
    notifyListeners();
  }

  void setSelectedAnswer(int selectedAnswer){
    this.selectedAnswer = selectedAnswer;
  }

}