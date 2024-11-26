
class FetchTransactionsModel {
    final String? transactionId;
    final String? accountId;
    final int? amount;
    final DateTime? createdAt;

    FetchTransactionsModel({
        this.transactionId,
        this.accountId,
        this.amount,
        this.createdAt,
    });

    factory FetchTransactionsModel.fromJson(Map<String, dynamic> json) => FetchTransactionsModel(
        transactionId: json["transaction_id"],
        accountId: json["account_id"],
        amount: json["amount"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "transaction_id": transactionId,
        "account_id": accountId,
        "amount": amount,
        "created_at": createdAt?.toIso8601String(),
    };
}
