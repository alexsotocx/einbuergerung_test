class Question {
  String text;
  String? link;
  String answer;
  List<String> options;
  int number;

  Question({
    required this.text,
    required this.answer,
    required this.options,
    required this.number,
    this.link,
  });

  static Question fromJson(dynamic json) {
    List<String> options = [
      ...List<String>.from(json['wrongAnswers']),
      json['answer']
    ];
    options.shuffle();
    return Question(
      text: json['text'],
      link: json['link'],
      answer: json['answer'],
      options: options,
      number: json['number'],
    );
  }
}
