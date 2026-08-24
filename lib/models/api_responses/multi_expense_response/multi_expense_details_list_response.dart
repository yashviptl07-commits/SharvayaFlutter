class MultipleExpenseDetailsListResponse {
  List<Details> details;
  int totalCount;

  MultipleExpenseDetailsListResponse({this.details, this.totalCount});

  MultipleExpenseDetailsListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = <Details>[];
      json['details'].forEach((v) {
        details.add(new Details.fromJson(v));
      });
    }
    totalCount = json['TotalCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.details != null) {
      data['details'] = this.details.map((v) => v.toJson()).toList();
    }
    data['TotalCount'] = this.totalCount;
    return data;
  }
}

class Details {
  int rowNum;
  int pkID;
  int refpkID;
  int expenseTypeId;
  double amount;
  String remarks;
  String fromLoc;
  String toLoc;
  dynamic voucher;
  String expenseTypeName;
  String expenseDateDetail;

  Details(
      {this.rowNum,
      this.pkID,
      this.refpkID,
      this.expenseTypeId,
      this.amount,
      this.remarks,
      this.fromLoc,
      this.toLoc,
      this.voucher,
      this.expenseTypeName,
      this.expenseDateDetail});

  Details.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'];
    pkID = json['pkID'];
    refpkID = json['RefpkID'];
    expenseTypeId = json['ExpenseTypeId'];
    amount = json['Amount'];
    remarks = json['Remarks'];
    fromLoc = json['FromLoc'];
    toLoc = json['ToLoc'];
    voucher = json['Voucher'];
    expenseTypeName = json['ExpenseTypeName'];
    expenseDateDetail = json['ExpenseDateDetail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['RefpkID'] = this.refpkID;
    data['ExpenseTypeId'] = this.expenseTypeId;
    data['Amount'] = this.amount;
    data['Remarks'] = this.remarks;
    data['FromLoc'] = this.fromLoc;
    data['ToLoc'] = this.toLoc;
    data['Voucher'] = this.voucher;
    data['ExpenseTypeName'] = this.expenseTypeName;
    data['ExpenseDateDetail'] = this.expenseDateDetail;
    return data;
  }
}
