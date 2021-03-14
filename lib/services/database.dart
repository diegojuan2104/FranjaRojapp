import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:franja_rojapp/models/ProfileModel.dart';
import 'package:franja_rojapp/models/QuestionModel.dart';
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

  saveAvatarData(List avatar_position) async {
    if (Auth().firebaseUser == null) return;
    await profilesCollection.doc(Auth().firebaseUser.uid).update({
      'avatar_position': avatar_position,
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
      return new ProfileModel(email, franjas, first_reward, avatar_created,
          questions_answered, avatar_position, glossary_opened, timestamp);
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
    await FirebaseDatabase.instance
        .reference()
        .child("Registro_de_Preguntas")
        .push()
        .child("pregunta")
        .set({
      'respuesta': answer,
      'fecha': datetime.toString(),
      'userId': Auth().firebaseUser.uid,
      'pregunta': questionText
    });

    //   await questionLogsCollection.doc().set({
    //     'quesitonId': questionId,
    //     'answer': answer,
    //     'timestamp': stamp,
    //     'userId': Auth().firebaseUser.uid,
    //     'question': questionText
    //   });
    await updateQuestionsAnsweredByUser(
        questionId, questions_answered_by_the_user);
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
