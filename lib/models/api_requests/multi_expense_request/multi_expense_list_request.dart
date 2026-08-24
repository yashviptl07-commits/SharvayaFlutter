/*
pkID:0
LoginUserID:admin
SearchKey:
PageNo:1
PageSize:10
CompanyId:45297*/

class MultiExpenseListRequest {
  String pkID;
  String LoginUserID;
  String SearchKey;
  String PageNo;
  String PageSize;
  String CompanyId;

  MultiExpenseListRequest(
      {this.pkID,
      this.LoginUserID,
      this.SearchKey,
      this.PageNo,
      this.PageSize,
      this.CompanyId});

  MultiExpenseListRequest.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    LoginUserID = json['LoginUserID'];
    SearchKey = json['SearchKey'];
    PageNo = json['PageNo'];
    PageSize = json['PageSize'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['LoginUserID'] = this.LoginUserID;
    data['SearchKey'] = this.SearchKey;
    data['PageNo'] = this.PageNo;
    data['PageSize'] = this.PageSize;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
