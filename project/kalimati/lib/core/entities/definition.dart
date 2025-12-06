class Definition {
  String text;
  String source;

  Definition({required this.text, required this.source});

  Map<String, dynamic> toJson() => {'text': text, 'source': source};

  factory Definition.fromJson(Map<String, dynamic> json) {
    return Definition(text: json['text'], source: json['source']);
  }
}
