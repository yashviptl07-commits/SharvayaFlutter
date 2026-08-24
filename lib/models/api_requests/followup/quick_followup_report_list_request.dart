class QuickFollowupReportListRequest {
  String CompanyId;
  String FromDate;
  String ToDate;
  String EmployeeID;
  String LoginUserID;

  QuickFollowupReportListRequest(
      {this.CompanyId,
      this.FromDate,
      this.ToDate,
      this.EmployeeID,
      this.LoginUserID});

  QuickFollowupReportListRequest.fromJson(Map<String, dynamic> json) {
    CompanyId = json['CompanyId'];
    FromDate = json['FromDate'];
    ToDate = json['ToDate'];
    EmployeeID = json['EmployeeID'];
    LoginUserID = json['LoginUserID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CompanyId'] = this.CompanyId;
    data['FromDate'] = this.FromDate;
    data['ToDate'] = this.ToDate;
    data['EmployeeID'] = this.EmployeeID;
    data['LoginUserID'] = this.LoginUserID;

    return data;
  }
}
