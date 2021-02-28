import 'package:json_annotation/json_annotation.dart';

part 'details.g.dart';

@JsonSerializable()
class Details {

  @JsonKey(name: "id") final int id;
  @JsonKey(name: "node_id") final String nodeId;
  @JsonKey(name: "login") final String login;
  @JsonKey(name: "url") final String url;
  @JsonKey(name: "avatar_url") final String avatarUrl;
  @JsonKey(name: "name") final String name;
  @JsonKey(name: "company") final String company;
  @JsonKey(name: "blog") final String blog;
  @JsonKey(name: "location") final String location;
  @JsonKey(name: "email") final String email;
  @JsonKey(name: "bio") final String bio;
  @JsonKey(name: "public_repos") final int publicRepos;
  @JsonKey(name: "public_gists") final int publicGists;
  @JsonKey(name: "followers") final int followers;
  @JsonKey(name: "following") final int following;
  @JsonKey(name: "created_at") final String createdAt;

  Details({
      this.id,
      this.nodeId,
      this.login,
      this.url,
      this.avatarUrl,
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
      this.createdAt
    });

  factory Details.fromJson(Map<String, dynamic> json) => _$DetailsFromJson(json);
  Map<String, dynamic> toJson() => _$DetailsToJson(this);

}
