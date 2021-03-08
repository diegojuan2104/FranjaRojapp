import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileModel {
  String email;
  bool avatar_created;
  bool first_reward;
  bool glossary_opened;
  int franjas;
  List questionsAnswered;
  List avatar_position;
  Timestamp timestamp;

  ProfileModel(this.email, this.franjas, this.first_reward, this.avatar_created,
      this.questionsAnswered, this.avatar_position, this.glossary_opened, this.timestamp);

  void setFranjas(int franjas) {
    this.franjas = franjas;
  }
}
