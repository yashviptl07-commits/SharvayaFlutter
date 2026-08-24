/*
pkID:0
LoginUserID:admin
SearchKey:
PageNo:1
PageSize:10
CompanyId:45297*/

class MultiExpenseApprovalListRequest {
  String pkID;
  String LoginUserID;
  String ApprovalStatus;
  String Month;
  String Year;
  String PageNo;
  String PageSize;
  String CompanyId;

  MultiExpenseApprovalListRequest(
      {this.pkID,
      this.LoginUserID,
      this.ApprovalStatus,
      this.Month,
      this.Year,
      this.PageNo,
      this.PageSize,
      this.CompanyId});

  MultiExpenseApprovalListRequest.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    LoginUserID = json['LoginUserID'];
    ApprovalStatus = json['ApprovalStatus'];
    Month = json['Month'];
    Year = json['Year'];
    PageNo = json['PageNo'];
    PageSize = json['PageSize'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['LoginUserID'] = this.LoginUserID;
    data['ApprovalStatus'] = this.ApprovalStatus;
    data['Month'] = this.Month;
    data['Year'] = this.Year;
    data['PageNo'] = this.PageNo;
    data['PageSize'] = this.PageSize;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
