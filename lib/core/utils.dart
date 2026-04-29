import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

String formatDate(String date) {
  DateTime dt = DateTime.parse(date);
  return DateFormat("yyyy.MM.dd").format(dt);
}

final dio = Dio(
  BaseOptions(
    baseUrl: "http://192.168.0.99:8080", // 서버 IP:PORT 입력
    contentType: "application/json; charset=utf-8",
  ),
);
