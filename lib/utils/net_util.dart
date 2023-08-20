//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/3/25
//
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

/// 网络请求工具类
class NetUtil {
  NetUtil._();

  static Dio? sDio;

  ///全局初始化
  static init(
      {String baseUrl = "",
      Duration timeout = const Duration(milliseconds: 5000),
      Map<String, dynamic>? headers}) {
    sDio = Dio(BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: timeout,
        sendTimeout: timeout,
        receiveTimeout: timeout,
        headers: headers));
    //添加拦截器
    sDio!.interceptors.add(LoggingInterceptor());
  }

  ///get请求
  static Future<Response<T>> get<T>(String path, [Map<String, dynamic>? params]) async {
    Response<T> response;
    if (params != null) {
      response = await sDio!.get<T>(path, queryParameters: params);
    } else {
      response = await sDio!.get<T>(path);
    }
    return response;
  }

  ///post 表单请求
  static Future<Response<T>> post<T>(String url, [Map<String, dynamic>? params]) async {
    Response<T> response = await sDio!.post<T>(url, queryParameters: params);
    return response;
  }

  ///post body请求
  static Future<Response<T>> postJson<T>(String url, [Map<String, dynamic>? data]) async {
    Response<T> response = await sDio!.post<T>(url, data: data);
    return response;
  }

  ///get请求
  static Future<Response<T>> getUri<T>(Uri url, [Map<String, dynamic>? params]) async {
    Response<T> response = await sDio!.getUri<T>(url);
    return response;
  }

  ///post请求
  static Future<Response<T>> postUri<T>(Uri url, [Map<String, dynamic>? params]) async {
    Response<T> response = await sDio!.postUri<T>(url);
    return response;
  }

  ///下载文件
  static Future<Response> downloadFile(String urlPath, String savePath,
      {ProgressCallback? onReceiveProgress}) async {
    Response response = await sDio!.download(urlPath, savePath,
        onReceiveProgress: onReceiveProgress,
        options: Options(
          sendTimeout: Duration(milliseconds: 900000),
          receiveTimeout: Duration(milliseconds: 900000),
        ));
    return response;
  }
}

class LoggingInterceptor extends Interceptor {
  final Logger log = Logger();

  DateTime? startTime;

  DateTime? endTime;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    startTime = DateTime.now();
    log.d(
      '------------------- Start -------------------',
    );
    if (options.queryParameters.isEmpty) {
      log.d(
        'Request Url         : '
        '${options.method}'
        ' '
        '${options.baseUrl}'
        '${options.path}',
      );
    } else {
      log.d(
        'Request Url         : '
        '${options.method}  '
        '${options.baseUrl}${options.path}?'
        '${Transformer.urlEncodeMap(options.queryParameters)}',
      );
    }
    log.d(
      'Request ContentType : ${options.contentType}',
    );
    if (options.data != null) {
      log.d(
        'Request Data        : ${options.data.toString()}',
      );
    }
    log.d(
      'Request Headers     : ${options.headers.toString()}',
    );
    log.d('--');
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    endTime = DateTime.now();
    final int duration = endTime!.difference(startTime!).inMilliseconds;
    log.d(
      'Response_Code       : ${response.statusCode}',
    );
    // 输出结果
    log.d(
      'Response_Data       : ${response.data.toString()}',
    );
    log.d(
      '------------- End: $duration ms -------------',
    );
    handler.next(response);
  }

  @override
  void onError(
    DioError err,
    ErrorInterceptorHandler handler,
  ) {
    log.e(
      '------------------- Error -------------------',
    );
    handleError(err);
    handler.next(err);
  }

  void handleError(DioError e) {
    switch (e.type) {
      case DioErrorType.connectionTimeout:
        log.e("连接超时");
        break;
      case DioErrorType.sendTimeout:
        log.e("请求超时");
        break;
      case DioErrorType.receiveTimeout:
        log.e("响应超时");
        break;
      case DioErrorType.badResponse:
        log.e("出现异常");
        break;
      case DioErrorType.cancel:
        log.e("请求取消");
        break;
      default:
        log.e("未知错误");
        break;
    }
  }
}
