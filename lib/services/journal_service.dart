import 'dart:convert';
import 'package:flutter_webapi_first_course/services/http_interceptor.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/http.dart';

class JournalService {
  static const String url = "http://192.168.50.219:3000/";
  static const String learn = "learnhttp/";

  http.Client client = InterceptedClient.build(interceptors: [LoggingInterceptor()]);

  String getLearnUrl() {
    return "$url$learn";
  }

  register(String content) {
    client.post(
      Uri.parse(getLearnUrl()),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'content': content})
    );
  }

  Future<String> get() async {
    http.Response response = await client.get(Uri.parse(getLearnUrl()));
    return response.body;
  }
}
