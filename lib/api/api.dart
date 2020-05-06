import 'dart:core';
import 'dart:io';

import 'package:flutterclientsample/data/user.dart';
import 'package:http/http.dart' as Http;


class Api {

  static final String BASE_URL = "https://api.github.com";
  static final String USERS_DEFAULT_ID = "0";
  static final String USERS_PATH = "/users?since=";

  Http.Response _response;
  String _url;
  String _userId;

  Api([this._url]) {
    _url ??= BASE_URL;
    _userId = USERS_DEFAULT_ID;
  }

  Future<List<User>> getUsersJson({ String sinceUser, error(message) }) async {
    try {
      final userId = sinceUser ?? _userId;
      _response = await Http.get(_url + USERS_PATH + userId);

      if (200 <= _response.statusCode && _response.statusCode < 300) {
        final users = User.fromJson(_response.body);
        _userId = users.last.id;
        return Future.value(users);
      }

      throw HttpException(_response.reasonPhrase);

    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List<User>> getUserDefault() async {
    return getUsersJson(sinceUser: USERS_DEFAULT_ID);
  }

}