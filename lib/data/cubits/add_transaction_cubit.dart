
import 'package:coolerprodemo/utils/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../api/transaction_repo.dart';
import '../../models/add_transaction_model.dart';
import '../../utils/api_status.dart';
import '../../utils/common_functions.dart';
import '../states/add_transaction_state.dart';

class AddTransactionCubit extends Cubit<AddTransactionState> {
  AddTransactionCubit()
      : super(InitialAddTransactionState());
  Future<void> addTransaction({required AddTransactionModel addTransactionModel}) async{
      emit(AddTransactionLoading());
    try {
      final result = await TransactionRepoService.addTransaction(transactionObject: addTransactionModel);

      if (result is Success) {
       emit(TransactionAdded());
      } else if (result is Failure) {
        emit(AddTransactionError(error: ApiError(
        code: result.code,
        message: result.errorResponse,
      )));
      }
    } catch (e) {
      emit(AddTransactionError(error: ApiError(
        code: unknownError,
        message: "An error occurred while fetching transactions.",
      )));
    }
  }
  bool checkInputValidity({required String? accountId, required String? amount}){
    // Regex for UUID v4 validation
  final uuidV4Regex = RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-4[0-9a-fA-F]{3}-[89aAbB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$');
     if(accountId==null|| accountId.isEmpty||accountId.length<3){
      showToast('Enter valid account ID');
      return false;
     }if(!uuidV4Regex.hasMatch(accountId)){
           showToast('Enter valid UUID V4 account ID');
      return false;
     }
     if(amount==null|| amount.isEmpty){
      showToast('Enter valid amount');
      return false;
     }
     if(double.parse(amount)<=0.0){
      showToast('Enter valid amount');
      return false;
     }
     return true;
  }
}
