import 'dart:core';
import 'dart:io';

import 'package:flutterclientsample/data/details.dart';
import 'package:flutterclientsample/data/user.dart';
import 'package:http/http.dart' as Http;

class Api {

  static final String BASE_URL = "https://api.github.com";
  static final String USERS_DEFAULT_ID = "0";
  static final String USERS_PATH = "/users?since=";

  Http.Response _response;
  String _url;
  String _userId;
  bool _isUsersFuture;
  bool _isDetailsFuture;

  Api([this._url]) {
    _url ??= BASE_URL;
    _userId = USERS_DEFAULT_ID;
    _isUsersFuture = false;
    _isDetailsFuture = false;
  }

  Future<List<User>> getUsersJson({ String sinceUser, error(message) }) async {
    if (_isUsersFuture) {
      return Future.error("Request is still running");
    }

    try {
      _isUsersFuture = true;
      final userId = sinceUser ?? _userId;
      _response = await Http.get(Uri.parse(_url + USERS_PATH + userId));

      if (200 <= _response.statusCode && _response.statusCode < 300) {
        final users = User.fromJson(_response.body);
        _userId = users.last.id;
        return Future.value(users);
      }

      throw HttpException(_response.reasonPhrase);

    } catch (e) {
      return Future.error(e);
    } finally {
      _isUsersFuture = false;
    }
  }

  Future<List<User>> getUserDefault() async {
    return getUsersJson(sinceUser: USERS_DEFAULT_ID);
  }

  Future<Details> getDetailsJson(String detailsUrl, { error(message) }) async {
    if (_isDetailsFuture) {
      return Future.error("Request is still running");
    }

    try {
      _isDetailsFuture = true;
      _response = await Http.get(Uri.parse(detailsUrl));

      if (200 <= _response.statusCode && _response.statusCode < 300) {
        final details = Details.fromJson(_response.body);
        return Future.value(details);
      }

      throw HttpException(_response.reasonPhrase);

    } catch (e) {
      return Future.error(e);
    } finally {
      _isDetailsFuture = false;
    }
  }

}