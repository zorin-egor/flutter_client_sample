import 'dart:convert';

import 'package:flutterclientsample/data/user.dart';
import 'package:intl/intl.dart';

class Details extends User {

  static Details fromJson(String json) {
    return Details.fromMap(jsonDecode(json) as Map);
  }

  String name;
  String company;
  String blog;
  String location;
  String email;
  String bio;
  String publicRepos;
  String publicGists;
  String followers;
  String following;
  String createdAt;

  Details({
      this.name,
      this.company,
      this.blog,
      this.location,
      this.email,
      this.bio,
      this.publicRepos,
      this.publicGists,
      this.followers,
      this.following,
      this.createdAt,
      id,
      nodeId,
      login,
      url,
      avatarUrl
    }) : super(
      id: id,
      nodeId: nodeId,
      login: login,
      url: url,
      avatarUrl: avatarUrl
  );

  @override
  String toString() => "${super.toString()}:"
      "$name:$company:$blog:$location:$email:$bio:"
      "$publicRepos:$publicGists:$followers:$following:$createdAt";

  @override
  Details.fromMap(Map<String, dynamic> json)
      : name = json['name'].toString(),
        company = json['company'].toString(),
        blog = json['blog'].toString(),
        location = json['location'].toString(),
        email = json['email'].toString(),
        bio = json['bio'].toString(),
        publicRepos = json['public_repos'].toString(),
        publicGists = json['public_gists'].toString(),
        followers = json['followers'].toString(),
        following = json['following'].toString(),
        createdAt = json['created_at'].toString(),
        super.fromMap(json);

  @override
  Map<String, dynamic> toJson() => {
    'name' : name,
    'company' : company,
    'blog' : blog,
    'location' : location,
    'email' : email,
    'bio' : bio,
    'public_repos' : publicRepos,
    'public_gists' : publicGists,
    'followers' : followers,
    'following' : following,
    'created_at' : createdAt,
    ...super.toJson()
  };

  Map<String, String> toPretty() => {
    'name' : name,
    'company' : company,
    'blog' : blog,
    'location' : location,
    'email' : email,
    'bio' : bio,
    'public repos' : publicRepos,
    'public gists' : publicGists,
    'followers' : followers,
    'following' : following,
    'created at' : DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(createdAt)),
  };

}
