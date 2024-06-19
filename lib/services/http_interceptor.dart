import 'package:http_interceptor/http_interceptor.dart';
import 'package:logger/logger.dart';

class LoggingInterceptor implements InterceptorContract {
  Logger logger = Logger();
  
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    logger.v("Request: ${data.baseUrl}\nHeaders: ${data.headers}\nBody: ${data.body}");
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    if(data.statusCode ~/ 100 == 2) {
      logger.i("Request: ${data.url}\nStatus: ${data.statusCode}\nHeaders: ${data.headers}\nBody: ${data.body}");
    } else {
      logger.e("Request: ${data.url}\nStatus: ${data.statusCode}\nHeaders: ${data.headers}\nBody: ${data.body}");
    }

    return data;
  }

}