import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {

  @JsonKey(name: "id") int id;
  @JsonKey(name: "login") String login;
  @JsonKey(name: "url") String url;
  @JsonKey(name: "node_id") String nodeId;
  @JsonKey(name: "avatar_url") String avatarUrl;

  User({
    this.id,
    this.nodeId,
    this.login,
    this.url,
    this.avatarUrl
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

}
