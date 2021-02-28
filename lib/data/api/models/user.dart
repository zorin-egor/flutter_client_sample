import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {

  @JsonKey(name: "id") final int id;
  @JsonKey(name: "login") final String login;
  @JsonKey(name: "url") final String url;
  @JsonKey(name: "node_id") final String nodeId;
  @JsonKey(name: "avatar_url") final String avatarUrl;

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
