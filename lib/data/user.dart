import 'dart:convert';

class User {

  static List<User> fromJson(String json) {
    return (jsonDecode(json) as List)
        .map((item) => User.fromMap(item))
        .toList();
  }

  String id;
  String nodeId;
  String login;
  String url;
  String avatarUrl;

  User({
    this.id,
    this.nodeId,
    this.login,
    this.url,
    this.avatarUrl
  });

  @override
  String toString() => "$id:$nodeId:$login:$url:$avatarUrl";

  User.fromMap(Map<String, dynamic> json)
      : id = json['id'].toString(),
        nodeId = json['node_id'].toString(),
        login = json['login'].toString(),
        url = json['url'].toString(),
        avatarUrl = json['avatar_url'].toString();

  Map<String, dynamic> toJson() => {
    'id' : id,
    'node_id' : nodeId,
    'login' : login,
    'url' : url,
    'avatar_url' : avatarUrl
  };

}
