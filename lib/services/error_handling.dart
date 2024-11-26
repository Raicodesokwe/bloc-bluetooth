
import 'package:dio/dio.dart';
import '../utils/common_functions.dart';
import '../utils/constants.dart';

class ResponseHandling {
  static Future<Response> handleResponse(Response response) async {
    switch (response.statusCode) {
      case unauthorizedError:
        showToast("UNAUTHORISED ACCESS");
        return response;
      case unknownError:
        showToast("UNAUTHORISED ACCESS");
        return response;
      default:
        return response;
    }
  }
}
