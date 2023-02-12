class Letter {
  int? id;
  String? firstLine;
  String? mainContent;
  int? sentAt;

  Letter({this.id, this.firstLine, this.mainContent, this.sentAt});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) {
      data['id'] = id;
    }
    data['FirstLine'] = firstLine;
    data['MainContent'] = mainContent;
    data['SentAt'] = sentAt;
    return data;
  }

  @override
  toString() {
    return {
      'id': id,
      'FirstLine': firstLine,
      'MainContent': mainContent,
      'SentAt': sentAt,
    }.toString();
  }
}
