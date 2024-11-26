
import 'package:coolerprodemo/screens/scan_screen.dart';
import'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/cubits/fetch_transactions_cubit.dart';
import '../utils/common_functions.dart';
import '../utils/navigation_utils.dart';
import '../widgets/label_text.dart';
import '../widgets/transaction_form.dart';
import '../widgets/transactions_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
     WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FetchTransactionsCubit>().fetchTransactions();
    });
    super.initState();
  }
@override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: RefreshIndicator(
        onRefresh: ()async{
        await  context.read<FetchTransactionsCubit>().fetchTransactions();
        },
        child: Scaffold(
          floatingActionButton: FloatingActionButton.extended(label:const Text('Bluetooth',style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600
          ),),
          icon: const Icon(Icons.bluetooth,color: Colors.white,),
         backgroundColor: Colors.deepPurple,
          onPressed: (){
openScreen(context, const ScanScreen());
          },
        
        ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: screenWidth(context) * .07,),
              const TransactionForm(),
               SizedBox(height: screenWidth(context) * .07,),
                const  LabelText(label: 'Historical Transactions',),
                 SizedBox(height: screenWidth(context) * .07,),
                const TransactionsList(),
                   SizedBox(height: screenWidth(context) * .07,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

