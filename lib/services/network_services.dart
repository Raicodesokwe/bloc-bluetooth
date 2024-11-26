import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';

import '../utils/constants.dart';
import 'error_handling.dart';

class NetworkServices{
    //POST
  static Future<Response> post({
    required String url,
    required Object data,
  }) async {
    log("POST : $url");
    log("PAYLOAD : $data");
    Response? response;
    try {
      response =
          await dio.post(url, data: jsonEncode(data),
          options: Options(
headers: headers
          ),
           );
    } on DioException catch (e) {
       
    if (e.response != null) {
      log("ERROR RESPONSE DATA: ${e.response?.data}");
      throw DioException(
        requestOptions: e.requestOptions,
        message: e.message, // Keep the error message for further use.
        response: e.response,
      );
    } else {
      throw DioException(
        requestOptions: e.requestOptions,
        message: e.message,
      );
    }
    }
    log("RESPONSE CODE : ${response.statusCode}");
    response = await ResponseHandling.handleResponse(response);
    return response;
  }
  
  // GET
  static Future<Response> get({
    required String url,
  }) async {
    log("GET : $url");
        
    Response? response;
    try {
      response = await dio.get(url);
    } on Exception catch (e) {
      log("RESPONSE CODE : $e");
    }
    
    log("RESPONSE CODE : ${response!.statusCode}");
    response = await ResponseHandling.handleResponse(response);
    return response;
  }
}