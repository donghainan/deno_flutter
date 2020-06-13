import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../config/service_url.dart';

class Http {
  static final String GET = 'get';
  static final String POST = 'post';
  static final String PUT = 'put';
  static final String DELETE = 'delete';

  static final String DATA = 'data';
  static final String CODE = 'errorCode';

  BaseOptions options = BaseOptions(
    baseUrl: baseUrl,
    headers: {},
    connectTimeout: 5000,
    receiveTimeout: 3000,
  );
  Dio dio;
  static Http _instance;
  static Http getInstance() {
    if (_instance == null) {
      _instance = Http();
    }
    return _instance;
  }

  Http() {
    dio = new Dio(options);
  }
  // get请求
  get(String url, Function successCallBack,
      {Map params, Function errorCallBack}) async {
    return _requstHttp(url, successCallBack, GET, params, errorCallBack);
  }

  // post请求
  post(String url, Function successCallBack,
      {Map params, Function errorCallBack}) async {
    return _requstHttp(url, successCallBack, GET, params, errorCallBack);
  }

  _requstHttp(String url, Function successCallBack,
      [String method, Map params, Function errorCallBack]) async {
    String errorMsg = '';
    int code;

    try {
      Response response;
      _addStartHttpInterceptor(dio); // 添加请求前的拦截器
      if (method == GET) {
        if (params != null && params.isNotEmpty) {
          response = await dio.get(url, queryParameters: params);
        } else {
          response = await dio.get(url);
        }
      } else if (method == POST || method == PUT || method == DELETE) {
        if (params != null && params.isNotEmpty) {
          response = await dio.post(url, data: params);
        } else {
          response = await dio.post(url);
        }
      }
      code = response.statusCode;
      if (code != 200) {
        errorMsg = '错误码：' + code.toString() + '，' + response.data.toString();
        _error(errorCallBack, errorMsg);
        return;
      }
      String dataStr = json.encode(response.data);
      Map<String, dynamic> dataMap = json.decode(dataStr);
      if (dataMap != null && dataMap[CODE] != 0) {
        errorMsg =
            '错误码：' + dataMap[CODE].toString() + '，' + response.data.toString();
        _error(errorCallBack, errorMsg);
        return;
      }

      successCallBack != null && successCallBack(dataMap[DATA]);
    } catch (exception) {
      _error(errorCallBack, exception.toString());
    }
  }

  _error(Function errorCallBack, String error) {
    Fluttertoast.showToast(
        msg: error.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER);
    errorCallBack != null && errorCallBack(error);
  }

  _addStartHttpInterceptor(Dio dio) {
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
      // 在请求被发送之前做一些事情
      Map<String, dynamic> headers = options.headers;
      headers['token'] = 'xxxx';
      return options; //continue
      // 如果你想完成请求并返回一些自定义数据，可以返回一个`Response`对象或返回`dio.resolve(data)`。
      // 这样请求将会被终止，上层then会被调用，then中返回的数据将是你的自定义数据data.
      //
      // 如果你想终止请求并触发一个错误,你可以返回一个`DioError`对象，或返回`dio.reject(errMsg)`，
      // 这样请求将被中止并触发异常，上层catchError会被调用。
    }, onResponse: (Response response) async {
      // 在返回响应数据之前做一些预处理
      return response; // continue
    }, onError: (DioError e) async {
      // 当请求失败时做一些预处理
      return e; //continue
    }));
  }
}
