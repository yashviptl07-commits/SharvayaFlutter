class DebitCreditNotesListRequest {
  int pkID;
  String DBC;
  String LoginUserID;
  String SearchKey;
  int PageNo;
  int CompanyId;
  int PageSize;

  DebitCreditNotesListRequest(
      {this.pkID,
      this.DBC,
      this.LoginUserID,
      this.SearchKey,
      this.PageNo,
      this.CompanyId,
      this.PageSize});

  DebitCreditNotesListRequest.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    DBC = json['DBC'];
    LoginUserID = json['LoginUserID'];
    SearchKey = json['SearchKey'];
    PageNo = json['PageNo'];
    CompanyId = json['CompanyId'];
    PageSize = json['PageSize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['DBC'] = this.DBC;
    data['LoginUserID'] = this.LoginUserID;
    data['SearchKey'] = this.SearchKey;
    data['PageNo'] = this.PageNo;
    data['CompanyId'] = this.CompanyId;
    data['PageSize'] = this.PageSize;

    return data;
  }
}
