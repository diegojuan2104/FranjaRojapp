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

  final questionLogsCollection =
      FirebaseFirestore.instance.collection('questionLogs');

  //Collection reference
  Future updateUserData(int franjas, String email, bool avatarCreated,
      bool firstReward, List<String> questions_answered) async {
    return await profilesCollection.doc(uid).set({
      'franjas': franjas,
      'email': email,
      'avatar_created': avatarCreated,
      'first_reward': firstReward,
      'questions_answered': questions_answered
    });
  }

  addFranjas(context, int franjasCurrentValue, int franjasToAdd) async {
    int franjas = franjasCurrentValue + franjasToAdd;
    await profilesCollection
        .doc(Auth().firebaseUser.uid)
        .update({'franjas': franjas});
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
    List<dynamic> questions_answered = snap.docs[0].get("questions_answered");

    return new ProfileModel(
        email, franjas, first_reward, avatar_created, questions_answered);
  }

  //This is to generate a question not answered by a user
  Future<QuestionModel> getQuestionData() async {
    List questions_answered_by_the_user;

    await DatabaseService().getCurrentProfile().then(
        (value) => {questions_answered_by_the_user = value.questionsAnswered});

    QuerySnapshot snap =
        await FirebaseFirestore.instance.collection('questions').get();

    List<dynamic> questionsList = shuffle(snap.docs);

    for (int i = 0; i < questionsList.length; i++) {
      //Verify if the user had answer that question

      if (!questions_answered_by_the_user
          .contains(questionsList[i].id.toString())) {
        String question = questionsList[i].get("question");
        int franjas = questionsList[i].get("franjas");
        List<dynamic> answers = questionsList[i].get("answers");
        bool intInputType = questionsList[i].get("intInputType");
        bool openQuestion = questionsList[i].get("openQuestion");
        final new_question = new QuestionModel(
          question: question,
          answers: answers,
          questionId: questionsList[i].id.toString(),
          franjas: franjas,
          intInputType: intInputType,
          openQuestion: openQuestion,
        );
        return new_question;
      }
    }
    final noQuestions = new QuestionModel(
        question: "noquestions", answers: [], questionId: null);
    return noQuestions;
  }

  //This update and answer: mainly to change the counter and add the user to users_who_responded
  createAnswerRegister(String answer, String questionId, String questionText,
      List questions_answered_by_the_user) async {
    Timestamp stamp = Timestamp.now();
    await questionLogsCollection.doc().set({
      'quesitonId': questionId,
      'answer': answer,
      'timestamp': stamp,
      'userId': Auth().firebaseUser.uid,
      'question': questionText
    });
    await updateQuestionsAnsweredByUser(
        questionId, questions_answered_by_the_user);
  }

  updateQuestionsAnsweredByUser(
      String questionId, List questions_answered_by_the_user) async {
    questions_answered_by_the_user.add(questionId);
    await profilesCollection.doc(Auth().firebaseUser.uid).update({
      'questions_answered': questions_answered_by_the_user,
    });
  }

  //This is to add questions to firebase
  createAQuestion(QuestionModel questionModel) async {
    return await questionsCollection.doc().set({
      'question': questionModel.question,
      'answers': questionModel.answers,
      'openQuestion': questionModel.openQuestion == null
          ? false
          : questionModel.openQuestion,
      'franjas': questionModel.franjas == null ? 5 : questionModel.franjas,
      'intInputType': questionModel.intInputType == null ? false : true,
    });
  }
}
