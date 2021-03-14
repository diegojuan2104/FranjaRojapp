class QuestionModel {
  final String question;
  final List<dynamic> answers;
  final String questionId;
  final bool openQuestion;
  final bool intInputType;
  final int franjas;
  int index;

  QuestionModel(
      {this.index,
      this.question,
      this.answers,
      this.questionId,
      this.openQuestion,
      this.intInputType,
      this.franjas});

  setIndex(int index) {
    this.index = index;
  }
}
