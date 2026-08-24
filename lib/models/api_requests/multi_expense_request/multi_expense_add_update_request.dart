/*
pkID:0
ExpenseDate:2025-09-10
VoucherNo:JE/2025-26/09/010
ExpenseNotes:API test
RequestID:0
AdvAmt:23
LoginUserID:admin
CompanyId:45297*/

class MultiExpenseAddUpdateRequest {
  String pkID;
  String ExpenseDate;
  String VoucherNo;
  String ExpenseNotes;
  String RequestID;
  String EmployeeID;
  String FromDate;
  String ToDate;
  String FromLocation;
  String ToLocation;
  String CustomerID;
  String ServiceEng;
  String ComplaintNo;
  String LoginUserID;
  String CompanyId;
  String RequestType;

  MultiExpenseAddUpdateRequest(
      {this.pkID,
      this.ExpenseDate,
      this.VoucherNo,
      this.ExpenseNotes,
      this.RequestID,
      this.EmployeeID,
      this.FromDate,
      this.ToDate,
      this.FromLocation,
      this.ToLocation,
      this.CustomerID,
      this.ServiceEng,
      this.ComplaintNo,
      this.LoginUserID,
      this.CompanyId,
      this.RequestType});

  MultiExpenseAddUpdateRequest.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    ExpenseDate = json['ExpenseDate'];
    VoucherNo = json['VoucherNo'];
    ExpenseNotes = json['ExpenseNotes'];
    RequestID = json['RequestID'];
    EmployeeID = json['EmployeeID'];
    FromDate = json['FromDate'];
    ToDate = json['ToDate'];
    FromLocation = json['FromLocation'];
    ToLocation = json['ToLocation'];
    CustomerID = json['CustomerID'];
    ServiceEng = json['ServiceEng'];
    ComplaintNo = json['ComplaintNo'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
    RequestType = json['RequestType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['ExpenseDate'] = this.ExpenseDate;
    data['VoucherNo'] = this.VoucherNo;
    data['ExpenseNotes'] = this.ExpenseNotes;
    data['RequestID'] = this.RequestID;
    data['EmployeeID'] = this.EmployeeID;
    data['FromDate'] = this.FromDate;
    data['ToDate'] = this.ToDate;
    data['FromLocation'] = this.FromLocation;
    data['ToLocation'] = this.ToLocation;
    data['CustomerID'] = this.CustomerID;
    data['ServiceEng'] = this.ServiceEng;
    data['ComplaintNo'] = this.ComplaintNo;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;
    data['RequestType'] = this.RequestType;

    return data;
  }
}
