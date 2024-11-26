import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
//Base url
String baseUrl = dotenv.env['BASE_URL']!;
//dio
Dio dio=Dio();
//Request headers
Map<String, String> get headers {

  return {
    "Content-Type": "application/json",
  };
}

//Errors
const noInternet = 100;
const apiError = 101;
const unknownError = 103;
const emptyFieldError = 104;
const unauthorizedError = 401;

//success and failure codes
const successCode = 200;
const successCreated = 201;
const successCodes = [200, 201, 202, 204];
const failureCodes = [400, 401, 402, 404, 500, 503];

//failure message
const String somethingWentWrong='Something went wrong';