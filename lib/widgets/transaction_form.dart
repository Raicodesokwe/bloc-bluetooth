import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/cubits/add_transaction_cubit.dart';
import '../data/states/add_transaction_state.dart';
import '../models/add_transaction_model.dart';
import '../utils/common_functions.dart';
import '../utils/navigation_utils.dart';
import 'common_text_field.dart';
import 'label_text.dart';
import 'title_text.dart';

class TransactionForm extends StatefulWidget {
  const TransactionForm({super.key});

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  String? accountId;

String? amount;
  @override
  Widget build(BuildContext context) {
      final addTransactionCubit = context.read<AddTransactionCubit>();
    return BlocListener<AddTransactionCubit, AddTransactionState>(
      listener: (context, state) {
        if (state is AddTransactionLoading) {
          showLoadingDialog(context); // Show loading dialog
        } else if (state is TransactionAdded) {
          showToast('Transaction added successfully. Pull down to refresh'); // Show success toast
        } else if (state is AddTransactionError) {
          showToast('${state.error.message}'); // Show error toast
        }
      },
        child: Column(
          children: [
           const  LabelText(label: 'Transaction Form',),
                
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child:   Card(
                  color: Colors.white,
                  surfaceTintColor: Colors.white,
                    child: Padding(
                      padding:const EdgeInsets.symmetric(horizontal: 20,vertical: 12),
                      child: Column(
                        children: [
                        const  TitleText(title: 'Account ID',),
                           SizedBox(height: screenWidth(context) * .025,),
                            CommonTextField(
                            onChanged: (value){
        accountId=value;
                            },
                          ),
                           SizedBox(height: screenWidth(context) * .025,),
                             const  TitleText(title: 'Amount',),
                           SizedBox(height: screenWidth(context) * .025,),
                            CommonTextField(
                              keyboardType:const TextInputType.numberWithOptions(decimal: true), // Allow decimal input
          inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')), // Allow only numbers and one decimal point
          ],
                            onChanged: (value){
        amount=value;
                            },),
                            SizedBox(height: screenWidth(context) * .065,),
                            GestureDetector(
                              onTap: ()async{
           if(addTransactionCubit.checkInputValidity(accountId: accountId, amount: amount)){
      
        final AddTransactionModel addTransactionModel=AddTransactionModel(accountId: accountId,amount: double.parse(amount!));
          await addTransactionCubit.addTransaction(addTransactionModel: addTransactionModel);
         if(mounted){
          navigationPop(context);
         }
           } 
                              },
                              child: Container(
                                width: double.infinity,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.purple,
                                  borderRadius: BorderRadius.circular(8)
                                ),
                                child:const Center(
                                  child: Text('Submit',style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700
                                  ),),
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
              )
          ],
        )
      
    );
  }
}


