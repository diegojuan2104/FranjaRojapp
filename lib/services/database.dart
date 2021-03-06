import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:franja_rojapp/models/ProfileModel.dart';
import 'package:franja_rojapp/models/questionModel.dart';
import 'package:franja_rojapp/services/auth.dart';
import 'package:intl/intl.dart';

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

  final tendederoCollection =
      FirebaseFirestore.instance.collection('tendedero');

  //Collection reference
  Future setInitialUserAttributes(String email) async {
    stamp = Timestamp.now();
    return await profilesCollection.doc(uid).set({
      'base64': '',
      'franjas': 0,
      'email': email,
      'avatar_created': false,
      'first_reward': false,
      'questions_answered': [],
      'timestamp': stamp,
      'avatar_position': [],
      'glossary_opened': false,
      'is_new_user': true,
      'tendedero_opened': false,
    });
  }

  addFranjas(context, int franjasCurrentValue, int franjasToAdd) async {
    int franjas = franjasCurrentValue + franjasToAdd;
    await profilesCollection
        .doc(Auth().firebaseUser.uid)
        .update({'franjas': franjas});
  }

  saveBase64(String base64) async {
    if (Auth().firebaseUser == null) return;
    await profilesCollection.doc(Auth().firebaseUser.uid).update({
      'base64': base64,
    });
  }

  saveFirstReward(bool firstReward) async {
    if (Auth().firebaseUser == null) return;
    await profilesCollection.doc(Auth().firebaseUser.uid).update({
      'first_reward': firstReward,
    });
  }

  saveAvatarCreated(bool avatarCreated) async {
    if (Auth().firebaseUser == null) return;
    await profilesCollection.doc(Auth().firebaseUser.uid).update({
      'avatar_created': true,
    });
  }

  saveGlossaryOpened(bool glossaryOpened) async {
    if (Auth().firebaseUser == null) return;
    await profilesCollection.doc(Auth().firebaseUser.uid).update({
      'glossary_opened': true,
    });
  }

  saveAvatarData(List avatar_position, String base64) async {
    if (Auth().firebaseUser == null) return;
    await saveBase64(base64);
    await profilesCollection.doc(Auth().firebaseUser.uid).update({
      'avatar_position': avatar_position,
    });
  }

  saveIsNewUser(bool isNewUser) async {
    if (Auth().firebaseUser == null) return;
    await profilesCollection.doc(Auth().firebaseUser.uid).update({
      'is_new_user': isNewUser,
    });
  }

  saveTendederoOpened(bool tendederoOpened) async {
    if (Auth().firebaseUser == null) return;
    await profilesCollection.doc(Auth().firebaseUser.uid).update({
      'tendedero_opened': tendederoOpened,
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
      List<dynamic> avatar_position = user.data()["avatar_position"];
      bool glossary_opened = user.data()["glossary_opened"];
      Timestamp timestamp = user.data()["timestamp"];
      bool isNewUser = user.data()["is_new_user"];
      String base64 = user.data()['base64'];
      bool tenderoOpened = user.data()["tendedero_opened"];
      return new ProfileModel(
          email,
          franjas,
          first_reward,
          avatar_created,
          questions_answered,
          avatar_position,
          glossary_opened,
          timestamp,
          isNewUser,
          tenderoOpened,
          base64);
    }
  }

  //This is to generate a question not answered by a user
  Future<QuestionModel> getQuestionData() async {
    final noQuestions = new QuestionModel(
        question: "noquestions", answers: [], questionId: null);
    if (Auth().firebaseUser == null) return noQuestions;
    List questions_answered_by_the_user;
    await DatabaseService().getCurrentProfile().then(
        (value) => {questions_answered_by_the_user = value.questionsAnswered});
    QuerySnapshot snap = await questionsCollection.orderBy("index").get();

    List<QueryDocumentSnapshot> questionsList = snap.docs;

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
    return noQuestions;
  }

  //This update and answer: mainly to change the counter and add the user to users_who_responded
  createAnswerRegister(String answer, String questionId, String questionText,
      List questions_answered_by_the_user) async {
    if (Auth().firebaseUser == null) return;
    Timestamp time = Timestamp.now();
    var datetime =
        DateTime.fromMicrosecondsSinceEpoch(time.microsecondsSinceEpoch);
    await FirebaseDatabase.instance.reference().child("Preguntas").push().set({
      'respuesta': answer,
      'fecha': datetime.toString(),
      'userId': Auth().firebaseUser.uid,
      'pregunta': questionText
    });

    await updateQuestionsAnsweredByUser(
        questionId, questions_answered_by_the_user);
  }

  createAnswerRegister2(String answer) async {
    if (Auth().firebaseUser == null) return;
    await FirebaseDatabase.instance.reference().child("tumamaputocanson").push().set({
      'respuesta': answer,
    
      
    });
  }

  Future createTendederoRegister(
      {String place,
      String placeDetails,
      String story,
      bool publicStory,
      dynamic avatarImg}) async {
    if (Auth().firebaseUser == null) return;
    Timestamp datetime = Timestamp.now();
    await FirebaseDatabase.instance.reference().child("Tendedero").push().set({
      'Lugar': place,
      'Fecha': datetime.toString(),
      'userId': Auth().firebaseUser.uid,
      'Detalles_Lugar': placeDetails,
      'Historia': story == null ? "No hay historia" : story,
      'Privacidad': publicStory == null
          ? "N/A"
          : publicStory
              ? "Pública"
              : "Privada",
    });
    // 'avatar_img': avatarImg

    await tendederoCollection.doc().set({
      'Lugar': place,
      'Fecha': datetime,
      'userId': Auth().firebaseUser.uid,
      'Detalles_Lugar': placeDetails,
      'Historia': story == null ? "No hay historia" : story,
      'Privacidad': publicStory == null
          ? "N/A"
          : publicStory
              ? "Pública"
              : "Privada",
    });
  }

  Future<List> getTendedero(String bloque) async {
    QuerySnapshot snap =
        await tendederoCollection.orderBy("Fecha", descending: true).get();
    List<QueryDocumentSnapshot> tendederoList = snap.docs;
    List storiesList = [];
    for (int i = 0; i < tendederoList.length; i++) {
      //Verify if the user had answer that question

      dynamic date = tendederoList[i].data()["Fecha"];
      String story = tendederoList[i].data()["Historia"];
      String place = tendederoList[i].data()["Lugar"];
      String privacy = tendederoList[i].data()["Privacidad"];

      date = DateFormat('yyyy-MM-dd  kk:mm').format(date.toDate());
      if (privacy == "Pública")
        storiesList.add({"date": date, "story": story, "place": place});
    }
    return storiesList;
  }

  updateQuestionsAnsweredByUser(
      String questionId, List questions_answered_by_the_user) async {
    if (Auth().firebaseUser == null) return;
    questions_answered_by_the_user.add(questionId);
    await profilesCollection.doc(Auth().firebaseUser.uid).update({
      'questions_answered': questions_answered_by_the_user,
    });
  }

  //This is to add questions to firebase
  createAQuestion(QuestionModel questionModel) async {
    await questionsCollection.doc().set({
      'question': questionModel.question,
      'answers': questionModel.answers,
      'openQuestion': questionModel.openQuestion == null
          ? false
          : questionModel.openQuestion,
      'franjas': questionModel.franjas == null ? 2 : questionModel.franjas,
      'intInputType': questionModel.intInputType == null ? false : true,
      'index': questionModel.index
    });
  }
}
