import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';

class HttpUtil {
  int code;

  static HttpUtil instance;
  Dio dio;
  BaseOptions options;
  CancelToken cancelToken = new CancelToken();

  static HttpUtil getInstance() {
    if (instance == null) {
      instance = new HttpUtil();
    }
    return instance;
  }

  ///构造器（初始化配置）
  HttpUtil() {
    // 基础配置 优先级 RequestOptions > Options > BaseOptions,按照优先级可以依次覆盖
    options = BaseOptions(
      // 请求基地址,可以包含子路径
      baseUrl: 'xxx',
      // 连接服务器超时时间，单位是毫秒.
      connectTimeout: 10000,
      // 响应流上前后两次接受到数据的间隔，单位为毫秒。
      receiveTimeout: 5000,
      // Http请求头.
      headers: {
        //do something
        'Accept': 'application/json, text/plain, */*',
        'Content-Type': 'application/json',
        "version": "1.0.0"
      },
      //请求的Content-Type，默认值是[ContentType.json]. 也可以用ContentType.parse("application/x-www-form-urlencoded")
      contentType: 'JSON',
      // 数据响应类型，接受4种类型 `json`, `stream`, `plain`, `bytes`. 默认值是 `json`
      responseType: ResponseType.json,
    );

    dio = new Dio(options);

    // 添加cookie管理
    var cookieJar = CookieJar();
    dio.interceptors.add(CookieManager(cookieJar));

    // 拦截器

    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.get("token");
      // 添加请求头token
      options.headers.addAll({"Authorization": "Bearer $token"});
      print("开始请求=========");
      return options;
    }, onResponse: (Response response) {
      print("请求成功===========");
      return response.data;
    }, onError: (DioError e) {
      return e;
    }));
  }

  /// get 请求
  get(String url,
      {Map<String, dynamic> data,
      Options options,
      CancelToken cancelToken}) async {
    Response response;
    try {
      response = await dio.get(url,
          queryParameters: data, options: options, cancelToken: cancelToken);
      code = response.statusCode;
    } catch (e) {
      formatError(e);
    }
    return response.data;
  }

  /// post请求
  post(String url,
      {Map<String, dynamic> data,
      Options options,
      CancelToken cancelToken}) async {
    Response response;
    try {
      response = await dio.post(url,
          data: data, options: options, cancelToken: cancelToken);
    } catch (e) {
      formatError(e);
    }
    return response.data;
  }

  /// error统一处理
  void formatError(DioError e) {
    if (e.type == DioErrorType.CONNECT_TIMEOUT) {
      print("连接超时");
    } else if (e.type == DioErrorType.SEND_TIMEOUT) {
      print("请求超时");
    } else if (e.type == DioErrorType.RECEIVE_TIMEOUT) {
      print("响应超时");
    } else if (e.type == DioErrorType.RESPONSE) {
      print("出现异常404 503");
    } else if (e.type == DioErrorType.CANCEL) {
      print("请求取消");
    } else {
      print("未知错误");
      if (code == 401) {
        // 401 错误处理
      }
    }
    Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER);
  }

  /*
   * 取消请求
   * 同一个cancel token 可以用于多个请求，当一个cancel token取消时，所有使用该cancel token的请求都会被取消。
   * 所以参数可选
   */
  void cancelRequests(CancelToken token) {
    token.cancel("cancelled");
  }
}
