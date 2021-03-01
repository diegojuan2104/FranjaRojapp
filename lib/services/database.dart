import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  Future updateUserData(int franjas, String email, bool avatarCreated,bool firstReward) async {
    return await profilesCollection.doc(uid).set({
      'franjas': franjas,
      'email': email,
      'AvatarCreated': false,
      'first_reward': false
    });
  }
}

