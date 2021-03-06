class ProfileModel{

  String email;
  bool avatar_created;
  bool first_reward;
  int franjas = 0;

  ProfileModel(this.email, this.franjas, this.first_reward, this.avatar_created);

  void setFranjas(int franjas){
    this.franjas = franjas;
  }

}