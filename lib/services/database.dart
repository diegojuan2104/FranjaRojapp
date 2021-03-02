import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:franja_rojapp/constants/constants.dart';
import 'package:franja_rojapp/services/auth.dart';

class DatabaseService {
  User firebaseUser = FirebaseAuth.instance.currentUser;
  String uid;

  DocumentReference specificProfileDocument;

  DatabaseService({this.uid}) {
    specificProfileDocument =
        FirebaseFirestore.instance.collection('profiles').doc(uid);
  }

  final profilesCollection = FirebaseFirestore.instance.collection('profiles');

  //Collection reference
  Future updateUserData(
      int franjas, String email, bool avatarCreated, bool firstReward) async {
    return await profilesCollection.doc(uid).set({
      'franjas': franjas,
      'email': email,
      'avatar_created': avatarCreated,
      'first_reward': firstReward
    });
  }

  addFranjas(context, int franjasCurrentValue, int franjasToAdd) async {
    simpleAlert(context, "Aviso", "Has ganado"+franjasToAdd.toString()+ "franjas");
    await profilesCollection
        .doc(Auth().firebaseUser != null ? Auth().firebaseUser.uid : "loading")
        .update({
      'franjas': franjasCurrentValue + franjasToAdd
    });
  }

  saveFirstReward(bool firstReward) async {
    await profilesCollection
        .doc(Auth().firebaseUser != null ? Auth().firebaseUser.uid : "loading")
        .update({
      'first_reward': firstReward,
    });
  }

  saveAvatarCreated(context,bool avatarCreated) async{
    simpleAlert(context, "Aviso", "Avatar Guardado");
    await profilesCollection
        .doc(Auth().firebaseUser != null ? Auth().firebaseUser.uid : "loading")
        .update({
      'avatar_created': true,
    });
    
  }
}
