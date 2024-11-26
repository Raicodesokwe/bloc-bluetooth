import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/cubits/fetch_transactions_cubit.dart';
import '../data/states/fetch_transactions_state.dart';
import 'circular_loading.dart';

class TransactionsList extends StatelessWidget {
  const TransactionsList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchTransactionsCubit, FetchTransactionsState>(
      builder: (context,state) {
        if (state is InitialFetchTransactionsState) {
         return const SizedBox.shrink();
       }else if (state is FetchTransactionsLoading) {
         return   const  CircularLoading();
       }else if (state is FetchTransactionsLoaded) {
       return Wrap(
         runSpacing: 15,
         children: List.generate(state.transactions.length, (index) {
            final transactionItem=state.transactions[index];
           return Padding(
             padding: const EdgeInsets.symmetric(horizontal: 20),
             child: Card(
             color: Colors.white,
             surfaceTintColor: Colors.white,
             child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 12),
             child: Text('Transferred \$${transactionItem.amount} from account ${transactionItem.accountId}'),
             ),
                            ),
           );
         }),
          
        );
       }else{
            return const SizedBox.shrink(); 
       }
       
      }
    );
  }
}

