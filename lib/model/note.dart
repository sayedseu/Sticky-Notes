class Note {
  final int id;
  final int userId;
  final String title;
  final String description;
  final String date;

  Note({this.id, this.userId, this.title, this.description, this.date});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "userId": userId,
      "title": title,
      "description": description,
      "date": date
    };
  }

  Note.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        userId = map["userId"],
        title = map["title"],
        description = map["description"],
        date = map["date"];
}
