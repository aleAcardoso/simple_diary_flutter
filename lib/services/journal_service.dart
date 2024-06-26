import 'dart:convert';
import 'package:flutter_webapi_first_course/services/http_interceptor.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/http.dart';

import '../models/journal.dart';

class JournalService {
  static const String url = "http://192.168.50.219:3000/";
  static const String journals = "journals/";

  http.Client client =
      InterceptedClient.build(interceptors: [LoggingInterceptor()]);

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

    if (response.statusCode == 201) {
      return true;
    }

    return false;
  }

  Future<bool> editJournal(String id, Journal journal, String token) async {
    http.Response response = await client.put(
        Uri.parse("${getJournalsUrl()}$id"),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: json.encode(journal.toMap()));

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }

  Future<List<Journal>> getAll({required int id, required String token}) async {
    http.Response response = await client.get(
        Uri.parse("${url}users/$id/$journals"),
        headers: {"Authorization": "Bearer $token"});

    if (response.statusCode != 200) {
      throw Exception();
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

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }
}
