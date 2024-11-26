import 'package:coolerprodemo/utils/api_status.dart';

abstract class AddTransactionState {}

class InitialAddTransactionState extends AddTransactionState {}

class AddTransactionLoading extends AddTransactionState {}

class TransactionAdded extends AddTransactionState {}

class AddTransactionError extends AddTransactionState {
  final ApiError error;

  AddTransactionError({required this.error});
}