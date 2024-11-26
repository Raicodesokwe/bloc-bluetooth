import 'package:coolerprodemo/utils/api_status.dart';

import '../../models/fetch_transactions_model.dart';

abstract class FetchTransactionsState {}

class InitialFetchTransactionsState extends FetchTransactionsState {}

class FetchTransactionsLoading extends FetchTransactionsState {}

class FetchTransactionsLoaded extends FetchTransactionsState {
   final List<FetchTransactionsModel> transactions;
  FetchTransactionsLoaded({required this.transactions});
}
class FetchTransactionsError extends FetchTransactionsState {
  final ApiError error;

  FetchTransactionsError({required this.error});
}