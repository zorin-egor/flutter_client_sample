import 'package:json_annotation/json_annotation.dart';
import 'package:intl/intl.dart';

part 'details.g.dart';

@JsonSerializable()
class Details {

  @JsonKey(name: "id") int id;
  @JsonKey(name: "node_id") String nodeId;
  @JsonKey(name: "login") String login;
  @JsonKey(name: "url") String url;
  @JsonKey(name: "avatar_url") String avatarUrl;
  @JsonKey(name: "name") String name;
  @JsonKey(name: "company") String company;
  @JsonKey(name: "blog") String blog;
  @JsonKey(name: "location") String location;
  @JsonKey(name: "email") String email;
  @JsonKey(name: "bio") String bio;
  @JsonKey(name: "public_repos") int publicRepos;
  @JsonKey(name: "public_gists") int publicGists;
  @JsonKey(name: "followers") int followers;
  @JsonKey(name: "following") int following;
  @JsonKey(name: "created_at") String createdAt;

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

  Map<String, dynamic> toPretty() => {
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
