class WithdrawPicker {
  String? withdrawpickerId;
  String? pickerId;
  String? amount;
  String? bankNum;
  String? bankName;

  WithdrawPicker(
      {this.withdrawpickerId,
      this.pickerId,
      this.amount,
      this.bankNum,
      this.bankName,
      }
  );

  WithdrawPicker.fromJson(Map<String, dynamic> json) {
    withdrawpickerId = json['withdrawpicker_id'];
    pickerId = json['picker_id'];
    amount = json['amount'];
    bankNum = json['bankNum'];
    bankName = json['bankName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['withdrawpicker_id '] = withdrawpickerId;
    data['picker_id'] = pickerId;
    data['amount'] = amount;
    data['bankNum'] = bankNum;
    data['bankName'] = bankName;
    return data;
  }
}