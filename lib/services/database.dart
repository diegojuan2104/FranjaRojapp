import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:franja_rojapp/constants/constants.dart';
import 'package:franja_rojapp/models/questionModel.dart';
import 'package:franja_rojapp/models/ProfileModel.dart';

import 'package:franja_rojapp/services/auth.dart';

class DatabaseService {
  User firebaseUser = FirebaseAuth.instance.currentUser;
  String uid;
  Timestamp stamp;

  DatabaseService({this.uid});

  final profilesCollection = FirebaseFirestore.instance.collection('profiles');
  final questionsCollection =
      FirebaseFirestore.instance.collection('questions');

  final questionLogsCollection =
      FirebaseFirestore.instance.collection('questionLogs');

  //Collection reference
  Future setInitialUserAttributes(String email) async {
    stamp = Timestamp.now();
    return await profilesCollection.doc(uid).set({
      'franjas': 0,
      'email': email,
      'avatar_created': false,
      'first_reward': false,
      'questions_answered': [],
      'timestamp': stamp,
      'avatar_position': [],
      'glossary_opened': false
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

  saveAvatarCreated(bool avatarCreated) async {
    await profilesCollection.doc(Auth().firebaseUser.uid).update({
      'avatar_created': true,
    });
  }

  saveGlossaryOpened(bool glossaryOpened) async {
    await profilesCollection.doc(Auth().firebaseUser.uid).update({
      'glossary_opened': true,
    });
  }

  Future<ProfileModel> getCurrentProfile() async {
    if (Auth().firebaseUser != null) {
      DocumentSnapshot user =
          await profilesCollection.doc(Auth().firebaseUser.uid).get();
      int franjas = user.data()["franjas"];
      String email = user.data()["email"];
      bool first_reward = user.data()["first_reward"];
      bool avatar_created = user.data()["avatar_created"];
      List<dynamic> questions_answered = user.data()["questions_answered"];
      List<dynamic> avatar_position = user.data()["questions_answered"];
      bool glossary_opened = user.data()["glossary_opened"];
      Timestamp timestamp = user.data()["timestamp"];
      return new ProfileModel(email, franjas, first_reward, avatar_created,
          questions_answered, avatar_position, glossary_opened, timestamp);
    }
  }

  //This is to generate a question not answered by a user
  Future<QuestionModel> getQuestionData() async {
    List questions_answered_by_the_user;
    await DatabaseService().getCurrentProfile().then(
        (value) => {questions_answered_by_the_user = value.questionsAnswered});
    QuerySnapshot snap = await questionsCollection.get();

    List<QueryDocumentSnapshot> questionsList = shuffle(snap.docs);

    for (int i = 0; i < questionsList.length; i++) {
      //Verify if the user had answer that question
      if (!questions_answered_by_the_user
          .contains(questionsList[i].id.toString())) {
        String question = questionsList[i].data()["question"];
        int franjas = questionsList[i].data()["franjas"];
        List<dynamic> answers = questionsList[i].data()["answers"];
        bool intInputType = questionsList[i].data()["intInputType"];
        bool openQuestion = questionsList[i].data()["openQuestion"];
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
    stamp = Timestamp.now();
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
