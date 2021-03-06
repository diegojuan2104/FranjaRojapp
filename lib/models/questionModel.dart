class QuestionModel{

  final String question;
  final List<dynamic> answers;
  final List<dynamic> users_who_responded;
  final String questionId;

  QuestionModel({this.question, this.answers, this.users_who_responded, this.questionId});
}