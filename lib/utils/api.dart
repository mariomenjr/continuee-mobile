import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;

class Api with DioMixin implements Dio {
  static Api? _instance;

  Api._internal([BaseOptions? baseOptions]) {
    options = baseOptions ??
        BaseOptions(baseUrl: "${dotenv.env["continuee-server"]}/");
    httpClientAdapter = DefaultHttpClientAdapter();

    _instance = this;
  }

  factory Api([BaseOptions? baseOptions]) =>
      _instance ?? Api._internal(baseOptions);
}
