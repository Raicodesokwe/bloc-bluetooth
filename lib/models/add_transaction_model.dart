
class AddTransactionModel {
    final String? accountId;
    final double? amount;

    AddTransactionModel({
        this.accountId,
        this.amount,
    });

    factory AddTransactionModel.fromJson(Map<String, dynamic> json) => AddTransactionModel(
        accountId: json["account_id"],
        amount: json["amount"],
    );

    Map<String, dynamic> toJson() => {
        "account_id": accountId,
        "amount": amount,
    };
}
