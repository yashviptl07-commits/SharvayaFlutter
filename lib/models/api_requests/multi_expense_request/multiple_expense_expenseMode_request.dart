/*
pkID:0
StatusCategory:
LoginUserID:admin
SearchKey:
PageNo:1
PageSize:10
CompanyId:45297*/

class MultiExpenseModeListRequest {
  String pkID;
  String StatusCategory;
  String LoginUserID;
  String SearchKey;
  String PageNo;
  String PageSize;
  String CompanyId;

  MultiExpenseModeListRequest(
      {this.pkID,
      this.StatusCategory,
      this.LoginUserID,
      this.SearchKey,
      this.PageNo,
      this.PageSize,
      this.CompanyId});

  MultiExpenseModeListRequest.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    StatusCategory = json['StatusCategory'];
    LoginUserID = json['LoginUserID'];
    SearchKey = json['SearchKey'];
    PageNo = json['PageNo'];
    PageSize = json['PageSize'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['StatusCategory'] = this.StatusCategory;
    data['LoginUserID'] = this.LoginUserID;
    data['SearchKey'] = this.SearchKey;
    data['PageNo'] = this.PageNo;
    data['PageSize'] = this.PageSize;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
