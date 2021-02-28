import 'dart:core';

import 'package:flutterclientsample/data/api/models/details.dart';
import 'package:flutterclientsample/data/api/models/user.dart';

import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'api_github.g.dart';

@RestApi(baseUrl: "https://api.github.com")
abstract class ApiGithub {

  factory ApiGithub(Dio dio, {String baseUrl}) = _ApiGithub;

  @GET("/users")
  Future<List<User>> getUsers(@Query("since") String since);

  @GET("{detailsUrl}")
  Future<Details> getDetails(@Path("detailsUrl") String url);

}