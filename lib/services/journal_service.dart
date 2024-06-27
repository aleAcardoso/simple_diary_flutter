import 'dart:convert';
import 'dart:io';
import 'package:flutter_webapi_first_course/services/web_client.dart';
import 'package:http/http.dart' as http;

import '../models/journal.dart';

class JournalService {
  http.Client client = WebClient().client;
  static const String url = WebClient.url;
  static const String journals = "journals/";


  String getJournalsUrl() {
    return "$url$journals";
  }

  Future<bool> registerJournal(Journal journal, String token) async {
    http.Response response = await client.post(Uri.parse(getJournalsUrl()),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: json.encode(journal.toMap()));

    if (response.statusCode != 201) {
      if (json.decode(response.body) == "jwt expired") {
        throw TokenNotValidException();
      }
      throw HttpException(response.body);
    }

    return true;
  }

  Future<bool> editJournal(String id, Journal journal, String token) async {
    journal.updatedAt = DateTime.now();
    http.Response response = await client.put(
        Uri.parse("${getJournalsUrl()}$id"),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: json.encode(journal.toMap()));

    if (response.statusCode != 200) {
      if (json.decode(response.body) == "jwt expired") {
        throw TokenNotValidException();
      }
      throw HttpException(response.body);
    }

    return true;
  }

  Future<List<Journal>> getAll({required int id, required String token}) async {
    http.Response response = await client.get(
        Uri.parse("${url}users/$id/$journals"),
        headers: {"Authorization": "Bearer $token"});

    if (response.statusCode != 200) {
      if (json.decode(response.body) == "jwt expired") {
        throw TokenNotValidException();
      }
      throw HttpException(response.body);
    }

    List<Journal> list = [];

    List<dynamic> listDynamic = json.decode(response.body);

    for (var map in listDynamic) {
      list.add(Journal.fromMap(map));
    }

    return list;
  }

  Future<bool> deleteJournal(String id, String token) async {
    http.Response response = await client.delete(
      Uri.parse("${getJournalsUrl()}$id"),
      headers: {"Authorization": "Bearer $token"}
    );

    if (response.statusCode != 200) {
      if (json.decode(response.body) == "jwt expired") {
        throw TokenNotValidException();
      }
      throw HttpException(response.body);
    }

    return true ;
  }
}

class TokenNotValidException implements Exception { }
