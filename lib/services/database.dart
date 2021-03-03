import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:franja_rojapp/constants/constants.dart';
import 'package:franja_rojapp/models/QuestionModel.dart';

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
  final questionsCollection =
      FirebaseFirestore.instance.collection('questions');

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
    simpleAlert(
        context, "Aviso", "Has ganado" + franjasToAdd.toString() + "franjas");
    await profilesCollection
        .doc(Auth().firebaseUser != null ? Auth().firebaseUser.uid : "loading")
        .update({'franjas': franjasCurrentValue + franjasToAdd});
  }

  saveFirstReward(bool firstReward) async {
    await profilesCollection
        .doc(Auth().firebaseUser != null ? Auth().firebaseUser.uid : "loading")
        .update({
      'first_reward': firstReward,
    });
  }

  saveAvatarCreated(context, bool avatarCreated) async {
    simpleAlert(context, "Aviso", "Avatar Guardado");
    await profilesCollection
        .doc(Auth().firebaseUser != null ? Auth().firebaseUser.uid : "loading")
        .update({
      'avatar_created': true,
    });
  }

  //This is to generate a question not answered by a user
   Future<QuestionModel> generateRandomQuestion() async {
    QuerySnapshot snap =
        await FirebaseFirestore.instance.collection('questions').get();
    List users_who_responded;
    for (int i = 0; i < snap.docs.length; i++) {
      users_who_responded = snap.docs[i].get("users_who_responded");

      //Verify if the user had answer that question 
      if (!users_who_responded.contains(Auth().firebaseUser.uid)) {
        String question = snap.docs[i].get("question");
        List<dynamic>answers = snap.docs[i].get("answers");
        List users_who_responded = snap.docs[i].get("users_who_responded");

        final new_question = new QuestionModel(
            question: question,
            answers: answers,
            users_who_responded: users_who_responded);
        return new_question;
      }
    }
    return null;
  }

  //This is to add questions to firebase
  createAQuestion(String question, List<Map> answers,
      List<String> usersWhoresponded) async {
    return await questionsCollection.doc().set({
      'question': question,
      'answers': answers,
      'users_who_responded': usersWhoresponded
    });
  }
}
