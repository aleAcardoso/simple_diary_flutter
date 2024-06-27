import 'dart:convert';
import 'dart:io';
import 'package:flutter_webapi_first_course/services/web_client.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String url = WebClient.url;
  static const String registerUrl = "register/";
  static const String loginUrl = "login";

  http.Client client = WebClient().client;

  Future<bool> login({required String email, required String password}) async {
    http.Response response = await client.post(
      Uri.parse("$url$loginUrl"),
      body: {
        "email": email,
        "password": password
      }
    );

    if (response.statusCode != 200) {
      String content = json.decode(response.body);
      switch (content) {
        case "Cannot find user" :
          throw UserNotFindException();
      }
    }

    saveUserInfos(response.body);

    return true;
  }

  Future<bool> register({required String email, required String password}) async {
    http.Response response = await client.post(
        Uri.parse("$url$registerUrl"),
        body: {
          "email": email,
          "password": password
        }
    );

    if (response.statusCode != 201) {
      throw HttpException(response.body);
    }

    saveUserInfos(response.body);

    return true;
  }

  saveUserInfos(String body) async {
    Map<String, dynamic> map = json.decode(body);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("accessToken", map["accessToken"]);
    prefs.setString("email", map["user"]["email"]);
    prefs.setInt("id", map["user"]["id"]);
  }
}

class UserNotFindException implements Exception {}
