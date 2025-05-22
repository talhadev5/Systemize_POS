import 'package:dio/dio.dart';

setCustomHeader(Dio dio, String key, String value) {
  dio.options.headers[key] = value;
}

setLanguageHeader(Dio dio, String key, String value) {
  dio.options.headers[key] = value;
}

setAcceptHeader(Dio dio) {
   dio.options.headers['Accept'] = 'application/json';
  //dio.options.headers['Accept'] = '*/*';
}

setContentHeader(Dio dio) {
  dio.options.headers['Content-Type'] = 'application/json';
  //dio.options.headers['Content-Type'] = '*/*';
}