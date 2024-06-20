import 'dart:convert';
import 'package:flutter_webapi_first_course/services/http_interceptor.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/http.dart';

import '../models/journal.dart';

class JournalService {
  static const String url = "http://192.168.50.219:3000/";
  static const String journals = "journals/";

  http.Client client = InterceptedClient.build(interceptors: [LoggingInterceptor()]);

  String getJournalsUrl() {
    return "$url$journals";
  }

  Future<bool> registerJournal(Journal journal) async {
    http.Response response = await client.post(
      Uri.parse(getJournalsUrl()),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(journal.toMap())
    );

    if (response.statusCode == 201) {
      return true;
    }

    return false;
  }

  Future<Journal?> get(String id) async {
    List<Journal> items = await getAll();
    Journal? response = items.where((journal) => journal.id == id).toList().first;
    return response;
  }

  Future<List<Journal>> getAll() async {
    http.Response response = await client.get(Uri.parse(getJournalsUrl()));

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
}
