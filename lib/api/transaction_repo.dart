import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

import '../models/add_transaction_model.dart';
import '../models/fetch_transactions_model.dart';
import '../services/network_services.dart';
import '../utils/api_status.dart';
import '../utils/common_functions.dart';
import '../utils/constants.dart';

class TransactionRepoService{
  static Future<Object> addTransaction({required AddTransactionModel transactionObject})async{
 if (!await checkInternetConnection()) {
        return Failure(code: noInternet, errorResponse: "No Internet");
      }
       try {
  var url = Uri.https(baseUrl, '/api/transaction-management/transactions');
   final map = transactionObject.toJson();
   // Log the payload as a JSON string
      Response response = await NetworkServices.post(url: '$url', data: map);
        log("RESPONSE ADD TRANSACTION ${response.statusCode}: ${response.data.toString()}");
       if (successCodes.contains(response.statusCode)) {
     final addTransactionResponse= response.data;
       
        return Success(
          code: successCode,
          response: addTransactionResponse,
        );
      } else {
        
        return Failure(
          code: unknownError,
          errorResponse: response.data['errors'][0],
        );
      }
} on DioException catch (e) {
      return Failure(code: unknownError, errorResponse: e.response?.data['errors'][0]);
}

 
  }  
 static Future<Object> getTransactions()async{
 if (!await checkInternetConnection()) {
        return Failure(code: noInternet, errorResponse: "No Internet");
      }
       try {
  var url = Uri.https(baseUrl, '/api/transaction-management/transactions');
    log("FETCH TRANSACTIONS : ");
      Response response = await NetworkServices.get(url: '$url');
        log("RESPONSE FETCH TRANSACTIONS${response.statusCode}: ${response.data.toString()}");
       if (successCodes.contains(response.statusCode)) {
      
     final fetchTransactionsResponse= response.data;
        List<FetchTransactionsModel> fetchTransactionsList = fetchTransactionsResponse
            .map<FetchTransactionsModel>((item) => FetchTransactionsModel.fromJson(item))
            .toList();
        return Success(
          code: successCode,
          response: fetchTransactionsList,
        );
      } else {
        
        return Failure(
          code: unknownError,
          errorResponse: jsonDecode(response.data)['error'],
        );
      }
} on Exception catch (e) {
      
      log(e.toString());
      return Failure(code: unknownError, errorResponse: somethingWentWrong);
}

 
  }
 

}