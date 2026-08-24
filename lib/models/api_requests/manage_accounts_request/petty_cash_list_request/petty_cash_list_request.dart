class PettyCashListRequest {
  int pkID;
  String LoginUserID;
  String SearchKey;
  String Status;
  int Month;
  int Year;
  int PageNo;
  int PageSize;
  int CompanyId;

  PettyCashListRequest(
      {this.pkID,
      this.LoginUserID,
      this.SearchKey,
      this.Status,
      this.Month,
      this.Year,
      this.PageNo,
      this.PageSize,
      this.CompanyId});

  PettyCashListRequest.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    LoginUserID = json['LoginUserID'];
    SearchKey = json['SearchKey'];
    Status = json['Status'];
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
    data['SearchKey'] = this.SearchKey;
    data['Status'] = this.Status;
    data['Month'] = this.Month;
    data['Year'] = this.Year;
    data['PageNo'] = this.PageNo;
    data['PageSize'] = this.PageSize;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
