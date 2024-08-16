import 'dart:developer';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:starter/app/data/values/constants.dart';
import 'package:starter/app/data/values/env.dart';
import 'package:starter/utils/helper/exception_handler.dart';

class NewNetworkRequester {
  late Dio _dio;

  NewNetworkRequester() {
    prepareRequest();
  }

  void prepareRequest() {
    BaseOptions dioOptions = BaseOptions(
      connectTimeout: Duration(milliseconds: Timeouts.CONNECT_TIMEOUT),
      receiveTimeout: Duration(milliseconds: Timeouts.RECEIVE_TIMEOUT),
      baseUrl: Env.baseURL,
      contentType: Headers.formUrlEncodedContentType,
      responseType: ResponseType.json,
      headers: {'Accept': Headers.jsonContentType},
    );

    _dio = Dio(dioOptions);

    _dio.interceptors.clear();

    _dio.interceptors.add(LogInterceptor(
      error: true,
      request: true,
      requestBody: true,
      requestHeader: true,
      responseBody: true,
      responseHeader: true,
      logPrint: _printLog,
    ));
  }

  _printLog(Object object) => log(object.toString());

  Future<dynamic> get({
    required String path,
    Map<String, dynamic>? query,
  }) async {
    return await _runInIsolate(_dioGet, {'path': path, 'query': query});
  }

  Future<dynamic> post({
    required String path,
    Map<String, dynamic>? query,
    Map<String, dynamic>? data,
  }) async {
    return await _runInIsolate(_dioPost, {'path': path, 'query': query, 'data': data});
  }

  Future<dynamic> put({
    required String path,
    Map<String, dynamic>? query,
    Map<String, dynamic>? data,
  }) async {
    return await _runInIsolate(_dioPut, {'path': path, 'query': query, 'data': data});
  }

  Future<dynamic> patch({
    required String path,
    Map<String, dynamic>? query,
    Map<String, dynamic>? data,
  }) async {
    return await _runInIsolate(_dioPatch, {'path': path, 'query': query, 'data': data});
  }

  Future<dynamic> delete({
    required String path,
    Map<String, dynamic>? query,
    Map<String, dynamic>? data,
  }) async {
    return await _runInIsolate(_dioDelete, {'path': path, 'query': query, 'data': data});
  }

  Future<dynamic> _dioGet(Map<String, dynamic> params) async {
    try {
      final response = await _dio.get(params['path'], queryParameters: params['query']);
      return response.data;
    } on Exception catch (exception) {
      return ExceptionHandler.handleError(exception);
    }
  }

  Future<dynamic> _dioPost(Map<String, dynamic> params) async {
    try {
      final response = await _dio.post(
        params['path'],
        queryParameters: params['query'],
        data: params['data'],
      );
      return response.data;
    } on Exception catch (error) {
      return ExceptionHandler.handleError(error);
    }
  }

  Future<dynamic> _dioPut(Map<String, dynamic> params) async {
    try {
      final response = await _dio.put(
        params['path'],
        queryParameters: params['query'],
        data: params['data'],
      );
      return response.data;
    } on Exception catch (error) {
      return ExceptionHandler.handleError(error);
    }
  }

  Future<dynamic> _dioPatch(Map<String, dynamic> params) async {
    try {
      final response = await _dio.patch(
        params['path'],
        queryParameters: params['query'],
        data: params['data'],
      );
      return response.data;
    } on Exception catch (error) {
      return ExceptionHandler.handleError(error);
    }
  }

  Future<dynamic> _dioDelete(Map<String, dynamic> params) async {
    try {
      final response = await _dio.delete(
        params['path'],
        queryParameters: params['query'],
        data: params['data'],
      );
      return response.data;
    } on Exception catch (error) {
      return ExceptionHandler.handleError(error);
    }
  }

  Future<dynamic> _runInIsolate(Function handler, Map<String, dynamic> params) async {
    final receivePort = ReceivePort();
    await Isolate.spawn(_isolateEntry, {'sendPort': receivePort.sendPort, 'handler': handler, 'params': params});
    return await receivePort.first;
  }

  static void _isolateEntry(Map<String, dynamic> message) async {
    SendPort sendPort = message['sendPort'];
    Function handler = message['handler'];
    Map<String, dynamic> params = message['params'];

    final result = await handler(params);
    sendPort.send(result);
  }
}
