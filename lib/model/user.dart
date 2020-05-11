class User {
  final int id;
  final String username;
  final String password;

  User({this.id, this.username, this.password});

  Map<String, dynamic> toMap() {
    return {"id": id, "username": username, "password": password};
  }

  User.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        username = map["username"],
        password = map["password"];
}
