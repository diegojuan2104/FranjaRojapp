import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:franja_rojapp/constants/constants.dart';
import 'package:franja_rojapp/models/QuestionModel.dart';
import 'package:franja_rojapp/models/profileModel.dart';

import 'package:franja_rojapp/services/auth.dart';

class DatabaseService {
  User firebaseUser = FirebaseAuth.instance.currentUser;
  String uid;

  DatabaseService({this.uid});

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
    await profilesCollection
        .doc(Auth().firebaseUser.uid)
        .update({'franjas': franjasCurrentValue + franjasToAdd});
  }

  saveFirstReward(bool firstReward) async {
    await profilesCollection.doc(Auth().firebaseUser.uid).update({
      'first_reward': firstReward,
    });
  }

  saveAvatarCreated(context, bool avatarCreated) async {
    simpleAlert(context, "Aviso", "Avatar Guardado");
    await profilesCollection.doc(Auth().firebaseUser.uid).update({
      'avatar_created': true,
    });
  }

  Future<ProfileModel> getCurrentProfile() async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('profiles')
        .where('email', isEqualTo: firebaseUser.email)
        .limit(1)
        .get();

    int franjas = snap.docs[0].get("franjas");
    String email = snap.docs[0].get("email");
    bool first_reward = snap.docs[0].get("first_reward");
    bool avatar_created = snap.docs[0].get("avatar_created");

    return new ProfileModel(email, franjas, first_reward, avatar_created);
  }

  //This is to generate a question not answered by a user
  Future<QuestionModel> generateRandomQuestion() async {
    QuerySnapshot snap =
        await FirebaseFirestore.instance.collection('questions').get();
    List<dynamic> users_who_responded;
    print(snap.docs.length);
    for (int i = 0; i < snap.docs.length; i++) {
      users_who_responded = snap.docs[i].get("users_who_responded");
      //Verify if the user had answer that question
      if (!users_who_responded.contains(Auth().firebaseUser.uid)) {
        String question = snap.docs[i].get("question");
        List<dynamic> answers = snap.docs[i].get("answers");
        final new_question = new QuestionModel(
            question: question,
            answers: answers,
            users_who_responded: users_who_responded,
            questionId: snap.docs[i].id.toString());
        return new_question;
      }
    }
    final noQuestions = new QuestionModel(
            question: "noquestions",
            answers: [],
            users_who_responded: [],
            questionId: null);
    return noQuestions;
  }

  //This update and answer: mainly to change the counter and add the user to users_who_responded
  updateQuestion(List<dynamic> answers, List<dynamic> users_who_responded,
      String questionId) async {
    await questionsCollection.doc(questionId).update(
        {'answers': answers, 'users_who_responded': users_who_responded});
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
