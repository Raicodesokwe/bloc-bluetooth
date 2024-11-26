
import 'package:coolerprodemo/data/states/fetch_transactions_state.dart';
import 'package:coolerprodemo/utils/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/transaction_repo.dart';
import '../../models/fetch_transactions_model.dart';
import '../../utils/api_status.dart';

class FetchTransactionsCubit extends Cubit<FetchTransactionsState> {
  FetchTransactionsCubit()
      : super(InitialFetchTransactionsState());
  Future<void> fetchTransactions() async{
      emit(FetchTransactionsLoading());
    try {
      final result = await TransactionRepoService.getTransactions();

      if (result is Success) {
        List<FetchTransactionsModel> transactions = result.response as List<FetchTransactionsModel>;
        emit(FetchTransactionsLoaded(transactions:transactions));
      } else if (result is Failure) {
        emit(FetchTransactionsError(error: ApiError(
        code: result.code,
        message: result.errorResponse,
      )));
      }
    } catch (e) {
      emit(FetchTransactionsError(error: ApiError(
        code: unknownError,
        message: "An error occurred while fetching transactions.",
      )));
    }
  }
}
