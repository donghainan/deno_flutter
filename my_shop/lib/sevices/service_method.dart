import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:io';
import '../config/service_url.dart';
import '../api/http_request.dart';

// 获取首页内容
Future getHomePageContent() async {
  var response = await HttpUtil.getInstance().get(
    servicePath['homePageContent'],
  );
  return response['data'];
}
