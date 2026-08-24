class ExpenseTrackingListRequest {
  String PKID;
  String EmployeeID;
  String CompanyID;
  String LoginUserID;
  String SearchKey;
  String FromDate;
  String ToDate;
  String PageNo;
  String PageSize;

  ExpenseTrackingListRequest(
      {this.PKID,
      this.EmployeeID,
      this.CompanyID,
      this.LoginUserID,
      this.SearchKey,
      this.FromDate,
      this.ToDate,
      this.PageNo,
      this.PageSize});

  ExpenseTrackingListRequest.fromJson(Map<String, dynamic> json) {
    PKID = json['PKID'];
    EmployeeID = json['EmployeeID'];
    CompanyID = json['CompanyID'];
    LoginUserID = json['LoginUserID'];
    SearchKey = json['SearchKey'];
    FromDate = json['FromDate'];
    ToDate = json['ToDate'];
    PageNo = json['PageNo'];
    PageSize = json['PageSize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PKID'] = this.PKID;
    data['EmployeeID'] = this.EmployeeID;
    data['CompanyID'] = this.CompanyID;
    data['LoginUserID'] = this.LoginUserID;
    data['SearchKey'] = this.SearchKey;
    data['FromDate'] = this.FromDate;
    data['ToDate'] = this.ToDate;
    data['PageNo'] = this.PageNo;
    data['PageSize'] = this.PageSize;
    return data;
  }
}
