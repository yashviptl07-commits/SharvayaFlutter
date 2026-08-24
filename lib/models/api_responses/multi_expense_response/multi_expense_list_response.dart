class MultiExpenseListResponse {
  List<MultiExpenseListResponseDetails> details;
  int totalCount;

  MultiExpenseListResponse({this.details, this.totalCount});

  MultiExpenseListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new MultiExpenseListResponseDetails.fromJson(v));
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

class MultiExpenseListResponseDetails {
  int rowNum;
  int pkID;
  String expenseDate;
  String employeename;
  String expenseNotes;
  int employeeID;
  String approvalStatus;
  String voucherNo;
  String fromDate;
  String toDate;
  String fromLocation;
  String toLocation;
  String serviceEng;
  String complaintNo;
  String createdBy;
  String createdDate;
  String updatedBy;
  String updatedDate;
  String approvedBy;
  String approvedDate;
  int requestID;
  String customerName;
  int customerID;
  String createdEmployeeName;
  String requestNotes;
  String updatedEmployeeName;
  String projectName;
  double amount;
  String requestType;

  MultiExpenseListResponseDetails(
      {this.rowNum,
      this.pkID,
      this.expenseDate,
      this.employeename,
      this.expenseNotes,
      this.employeeID,
      this.approvalStatus,
      this.voucherNo,
      this.fromDate,
      this.toDate,
      this.fromLocation,
      this.toLocation,
      this.serviceEng,
      this.complaintNo,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate,
      this.approvedBy,
      this.approvedDate,
      this.requestID,
      this.customerName,
      this.customerID,
      this.createdEmployeeName,
      this.requestNotes,
      this.updatedEmployeeName,
      this.projectName,
      this.amount,
      this.requestType});

  MultiExpenseListResponseDetails.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'];
    pkID = json['pkID'];
    expenseDate = json['ExpenseDate'];
    employeename = json['Employeename'];
    expenseNotes = json['ExpenseNotes'];
    employeeID = json['EmployeeID'];
    approvalStatus = json['ApprovalStatus'];
    voucherNo = json['VoucherNo'];
    fromDate = json['FromDate'];
    toDate = json['ToDate'];
    fromLocation = json['FromLocation'];
    toLocation = json['ToLocation'];
    serviceEng = json['ServiceEng'];
    complaintNo = json['ComplaintNo'];
    createdBy = json['CreatedBy'];
    createdDate = json['CreatedDate'];
    updatedBy = json['UpdatedBy'];
    updatedDate = json['UpdatedDate'];
    approvedBy = json['ApprovedBy'];
    approvedDate = json['ApprovedDate'];
    requestID = json['RequestID'];
    customerName = json['CustomerName'];
    customerID = json['CustomerID'];
    createdEmployeeName = json['CreatedEmployeeName'];
    requestNotes = json['RequestNotes'];
    updatedEmployeeName = json['UpdatedEmployeeName'];
    projectName = json['ProjectName'];
    amount = json['Amount'] == null ? 0.00 : json['Amount'];
    requestType = json['RequestType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['ExpenseDate'] = this.expenseDate;
    data['Employeename'] = this.employeename;
    data['ExpenseNotes'] = this.expenseNotes;
    data['EmployeeID'] = this.employeeID;
    data['ApprovalStatus'] = this.approvalStatus;
    data['VoucherNo'] = this.voucherNo;
    data['FromDate'] = this.fromDate;
    data['ToDate'] = this.toDate;
    data['FromLocation'] = this.fromLocation;
    data['ToLocation'] = this.toLocation;
    data['ServiceEng'] = this.serviceEng;
    data['ComplaintNo'] = this.complaintNo;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    data['UpdatedBy'] = this.updatedBy;
    data['UpdatedDate'] = this.updatedDate;
    data['ApprovedBy'] = this.approvedBy;
    data['ApprovedDate'] = this.approvedDate;
    data['RequestID'] = this.requestID;
    data['CustomerName'] = this.customerName;
    data['CustomerID'] = this.customerID;
    data['CreatedEmployeeName'] = this.createdEmployeeName;
    data['RequestNotes'] = this.requestNotes;
    data['UpdatedEmployeeName'] = this.updatedEmployeeName;
    data['ProjectName'] = this.projectName;
    data['Amount'] = this.amount;
    data['RequestType'] = this.requestType;
    return data;
  }
}
