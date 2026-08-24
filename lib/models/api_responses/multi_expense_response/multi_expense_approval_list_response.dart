class MultipleExpenseApprovalListResponse {
  List<MultipleExpenseApprovalListResponseDetails> details;
  int totalCount;

  MultipleExpenseApprovalListResponse({this.details, this.totalCount});

  MultipleExpenseApprovalListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new MultipleExpenseApprovalListResponseDetails.fromJson(v));
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

class MultipleExpenseApprovalListResponseDetails {
  int rowNum;
  int pkID;
  String voucherNo;
  String employeename;
  String expenseDate;
  String expenseNotes;
  String approvalStatus;
  String createdBy;
  String createdDate;
  String updatedBy;
  String updatedDate;
  String createdEmployeeName;
  String updatedEmployeeName;
  double amount;
  String approvalRemarks;

  MultipleExpenseApprovalListResponseDetails(
      {this.rowNum,
      this.pkID,
      this.voucherNo,
      this.employeename,
      this.expenseDate,
      this.expenseNotes,
      this.approvalStatus,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate,
      this.createdEmployeeName,
      this.updatedEmployeeName,
      this.amount,
      this.approvalRemarks});

  MultipleExpenseApprovalListResponseDetails.fromJson(
      Map<String, dynamic> json) {
    rowNum = json['RowNum'];
    pkID = json['pkID'];
    voucherNo = json['VoucherNo'];
    employeename = json['Employeename'];
    expenseDate = json['ExpenseDate'];
    expenseNotes = json['ExpenseNotes'];
    approvalStatus = json['ApprovalStatus'];
    createdBy = json['CreatedBy'];
    createdDate = json['CreatedDate'];
    updatedBy = json['UpdatedBy'];
    updatedDate = json['UpdatedDate'];
    createdEmployeeName = json['CreatedEmployeeName'];
    updatedEmployeeName = json['UpdatedEmployeeName'];
    amount = json['Amount'];
    approvalRemarks = json['ApprovalRemarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['VoucherNo'] = this.voucherNo;
    data['Employeename'] = this.employeename;
    data['ExpenseDate'] = this.expenseDate;
    data['ExpenseNotes'] = this.expenseNotes;
    data['ApprovalStatus'] = this.approvalStatus;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    data['UpdatedBy'] = this.updatedBy;
    data['UpdatedDate'] = this.updatedDate;
    data['CreatedEmployeeName'] = this.createdEmployeeName;
    data['UpdatedEmployeeName'] = this.updatedEmployeeName;
    data['Amount'] = this.amount;
    data['ApprovalRemarks'] = this.approvalRemarks;
    return data;
  }
}
