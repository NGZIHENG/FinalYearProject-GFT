class Withdraw {
  String? withdrawId;
  String? userId;
  String? amount;
  String? bankNum;
  String? bankName;

  Withdraw(
      {this.withdrawId,
      this.userId,
      this.amount,
      this.bankNum,
      this.bankName,
      }
  );

  Withdraw.fromJson(Map<String, dynamic> json) {
    withdrawId = json['withdraw_id'];
    userId = json['user_id'];
    amount = json['amount'];
    bankNum = json['bankNum'];
    bankName = json['bankName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['withdraw_id '] = withdrawId;
    data['user_id'] = userId;
    data['amount'] = amount;
    data['bankNum'] = bankNum;
    data['bankName'] = bankName;
    return data;
  }
}