import 'dart:convert';

class User {

  static List<User> fromJson(String json) {
    var jsonList = jsonDecode(json) as List;
    var userList = jsonList.map((item) => User.fromMap(item)).toList();
    return userList;
  }

  final String id;
  final String login;
  final String avatarUrl;

  User(this.id, this.login, this.avatarUrl);

  @override
  String toString() => "$id:$login:$avatarUrl";

  User.fromMap(Map<String, dynamic> json)
      : id = json['id'].toString(),
        login = json['login'].toString(),
        avatarUrl = json['avatar_url'].toString();

  Map<String, dynamic> toJson() => {
    'id' : id,
    'login' : login,
    'avatar_url' : avatarUrl
  };

}
