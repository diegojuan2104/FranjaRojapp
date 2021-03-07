class ProfileModel{
  String email;
  bool avatar_created;
  bool first_reward;
  int franjas = 0;
  List questionsAnswered = [];

  ProfileModel(this.email, this.franjas, this.first_reward, this.avatar_created, this.questionsAnswered);

  void setFranjas(int franjas){
    this.franjas = franjas;
  }
}