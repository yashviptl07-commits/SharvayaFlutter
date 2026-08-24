class TrialBalanceListRequest {
  String DBCR;
  String LoginUserID;
  int PageNo;
  int CompanyId;
  int PageSize;

  TrialBalanceListRequest(
      {this.DBCR,
      this.LoginUserID,
      this.PageNo,
      this.CompanyId,
      this.PageSize});

  TrialBalanceListRequest.fromJson(Map<String, dynamic> json) {
    DBCR = json['DBCR'];
    LoginUserID = json['LoginUserID'];
    PageNo = json['PageNo'];
    CompanyId = json['CompanyId'];
    PageSize = json['PageSize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DBCR '] = this.DBCR;
    data['LoginUserID'] = this.LoginUserID;
    data['PageNo'] = this.PageNo;
    data['CompanyId'] = this.CompanyId;
    data['PageSize'] = this.PageSize;

    return data;
  }
}
